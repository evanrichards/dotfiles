local nmap = require("helpers.keys").nmap
local vmap = require("helpers.keys").vmap
nmap("<C-h>", ":vertical resize +3<CR>", "Increase width of current buffer")
nmap("<C-l>", ":vertical resize -3<CR>", "Decrease width of current buffer")
nmap("<C-j>", ":resize +3<CR>", "Increase height of current buffer")
nmap("<C-k>", ":resize -3<CR>", "Decrease height of current buffer")

-- Deleting buffers
local buffers = require("helpers.buffers")
nmap("<leader>db", buffers.delete_this, "Current buffer")
-- lua/core/keymaps.lua
nmap("<leader>h", function()
	local buf = vim.api.nvim_get_current_buf()
	local ih = vim.lsp.inlay_hint
	local on = ih.is_enabled({ bufnr = buf })

	ih.enable(not on, { bufnr = buf }) -- boolean, then opts table
end, "Toggle inlay hints")

-- misc
-- in visual mode, when you indent a block, go back into visual mode
vmap("<", "<gv", "Reindent ‹")
vmap(">", ">gv", "Reindent ›")
-- clear search highlighting with <space>+</>
nmap("<leader>/", ":nohlsearch<CR>", "Clear hlsearch")
nmap("<leader>fw", "<cmd>w<cr>", "Write")

-- Copy file path (with line numbers in visual mode)
local function copy_file_reference()
	local file_path = vim.fn.expand("%:.")
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	local cwd = vim.fn.getcwd()

	-- Make path relative to git root if we're in a git repo
	if vim.v.shell_error == 0 and git_root and git_root ~= "" then
		file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":s?" .. git_root .. "/??")
	end

	vim.fn.setreg("+", file_path)
	print("Copied: " .. file_path)
end

local function copy_file_reference_with_lines()
	local file_path = vim.fn.expand("%:.")
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

	-- Make path relative to git root if we're in a git repo
	if vim.v.shell_error == 0 and git_root and git_root ~= "" then
		file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":s?" .. git_root .. "/??")
	end

	-- Get visual selection range
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")

	-- Ensure start is before end
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local reference
	if start_line == end_line then
		reference = file_path .. ":" .. start_line
	else
		reference = file_path .. ":" .. start_line .. "-" .. end_line
	end

	vim.fn.setreg("+", reference)
	print("Copied: " .. reference)
end

nmap("<leader>ly", copy_file_reference, "Copy file path")
vmap("<leader>ly", copy_file_reference_with_lines, "Copy file path with lines")
