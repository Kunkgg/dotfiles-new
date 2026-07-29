local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- auto-save: write when leaving insert mode or losing focus
local function should_autosave()
	local buf = vim.api.nvim_get_current_buf()
	return vim.bo[buf].modified -- has unsaved changes
		and vim.bo[buf].buftype == "" -- regular file buffer (not terminal/help/etc.)
		and vim.bo[buf].readonly == false -- not read-only
		and vim.api.nvim_buf_get_name(buf) ~= "" -- has a file name (not unnamed)
end

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
	group = augroup,
	desc = "Auto-save buffer",
	callback = function()
		if should_autosave() then
			vim.cmd("silent! write")
		end
	end,
})
