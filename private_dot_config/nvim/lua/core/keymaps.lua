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
