local M = {}

-- default config
M.config = {
	-- persistence
	-- TODO: implement this
	-- save_marks = false,
	-- marks_file = vim.fn.stdpath("data") .. "/buffer_marks.json",

	-- notifications
	notify = true,
	notify_on_mark = true,
	notify_on_jump = true,

	-- keymaps (set false to disable default keymaps)
	keymaps = {
		mark = "<leader>m",
		jump = "<leader>'",
		list = "<leader>fm",
		clear = "<leader>mc",
	},
}

-- init marks
_G.buffer_marks = _G.buffer_marks or {}

-- notification helper
local function notify(msg, level, title)
	if not M.config.notify then
		return
	end

	local message = title and string.format("[%s] %s", title, msg) or msg
	local log_level = vim.log.levels[string.upper(level or "info")]
	vim.notify(message, log_level)
end

-- mark buffer
function M.mark_buffer()
	local key = vim.fn.getcharstr()
	if key and #key == 1 and key:match("[a-zA-Z0-9]") then
		local bufnr = vim.api.nvim_get_current_buf()
		local bufname = vim.api.nvim_buf_get_name(bufnr)

		_G.buffer_marks = _G.buffer_marks or {}

		-- check if already marked, delete old if so
		local old_key = nil
		for existing_key, mark in pairs(_G.buffer_marks) do
			if mark.bufnr == bufnr or mark.bufname == bufname then
				if existing_key ~= key then
					old_key = existing_key
					_G.buffer_marks[existing_key] = nil
				end
				break
			end
		end

		-- add new mark
		_G.buffer_marks[key] = {
			bufnr = bufnr,
			bufname = bufname,
			timestamp = os.time(),
		}

		-- notify
		if M.config.notify_on_mark then
			if old_key then
				notify(
					string.format("Moved '%s' from [%s] to [%s]", vim.fn.fnamemodify(bufname, ":t"), old_key, key),
					"info"
				)
			else
				notify(string.format("Marked '%s' as [%s]", vim.fn.fnamemodify(bufname, ":t"), key), "info")
			end
		end
	end
end

-- jump to marked buffer
function M.jump_to_mark()
	local key = vim.fn.getcharstr()
	if key and #key == 1 then
		_G.buffer_marks = _G.buffer_marks or {}
		local mark = _G.buffer_marks[key]

		if mark then
			-- if buffer exists
			if vim.api.nvim_buf_is_valid(mark.bufnr) then
				vim.api.nvim_set_current_buf(mark.bufnr)
			else
				-- if deleted try to open
				vim.cmd("edit " .. vim.fn.fnameescape(mark.bufname))
			end

			-- jump to last edit position in
			vim.cmd('normal! g`"')

			if M.config.notify_on_jump then
				notify(string.format("Jumped to [%s]", key))
			end
		else
			notify(string.format("Buffer mark [%s] not found", key), "warn")
		end
	end
end

-- list all marks
function M.list_marks()
	_G.buffer_marks = _G.buffer_marks or {}

	local items = {}
	local display = {}
	for key, mark in pairs(_G.buffer_marks) do
		local filename = vim.fn.fnamemodify(mark.bufname, ":t")
		local dir = vim.fn.fnamemodify(mark.bufname, ":h:t")
		table.insert(items, {
			key = key,
			file = mark.bufname,
			bufnr = mark.bufnr,
			display = string.format("[%s] %s/%s", key, dir, filename),
		})
		table.insert(display, string.format("[%s] %s/%s", key, dir, filename))
	end

	-- sort by key
	table.sort(items, function(a, b)
		return a.key < b.key
	end)
	table.sort(display)

	if #items == 0 then
		notify("No buffer marks set", "info")
		return
	end

	vim.ui.select(display, {
		prompt = "Buffer Marks",
		format_item = function(item)
			return item
		end,
	}, function(choice, idx)
		if choice then
			local item = items[idx]
			if vim.api.nvim_buf_is_valid(item.bufnr) then
				vim.api.nvim_set_current_buf(item.bufnr)
			else
				vim.cmd("edit " .. vim.fn.fnameescape(item.file))
			end
			vim.cmd('normal! g`"')
		end
	end)
end

-- clear all marks
function M.clear_marks()
	_G.buffer_marks = {}
	notify("Cleared all buffer marks")
end

-- remove specific mark
function M.remove_mark(key)
	if _G.buffer_marks[key] then
		_G.buffer_marks[key] = nil
		notify(string.format("Removed mark [%s]", key))
	end
end

-- setup function
function M.setup(opts)
	-- merge user config with defaults
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- setup keymaps if enabled
	if M.config.keymaps then
		if M.config.keymaps.mark then
			vim.keymap.set("n", M.config.keymaps.mark, M.mark_buffer, { desc = "Mark buffer" })
		end
		if M.config.keymaps.jump then
			vim.keymap.set("n", M.config.keymaps.jump, M.jump_to_mark, { desc = "Jump to buffer mark" })
		end
		if M.config.keymaps.list then
			vim.keymap.set("n", M.config.keymaps.list, M.list_marks, { desc = "List buffer marks" })
		end
		if M.config.keymaps.clear then
			vim.keymap.set("n", M.config.keymaps.clear, M.clear_marks, { desc = "Clear buffer marks" })
		end
	end

	-- create user commands
	vim.api.nvim_create_user_command("BufferMarkSet", M.mark_buffer, { desc = "Mark current buffer" })
	vim.api.nvim_create_user_command("BufferMarkJump", M.jump_to_mark, { desc = "Jump to marked buffer" })
	vim.api.nvim_create_user_command("BufferMarkList", M.list_marks, { desc = "List all buffer marks" })
	vim.api.nvim_create_user_command("BufferMarkClear", M.clear_marks, { desc = "Clear all buffer marks" })
end

return M
