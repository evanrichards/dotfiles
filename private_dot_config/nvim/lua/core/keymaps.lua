local nmap = require("helpers.keys").nmap
local vmap = require("helpers.keys").vmap
nmap("<C-h>", ":vertical resize +3<CR>", "Increase width of current buffer")
nmap("<C-l>", ":vertical resize -3<CR>", "Decrease width of current buffer")
nmap("<C-j>", ":resize +3<CR>", "Increase height of current buffer")
nmap("<C-k>", ":resize -3<CR>", "Decrease height of current buffer")
nmap("<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, "Toggle inlay hints")

-- in visual mode, when you indent a block, go back into visual mode
vmap("<", "<gv")
vmap(">", ">gv")
-- clear search highlighting with <space>+</>
nmap("<leader>/", ":nohlsearch<CR>")

nmap("<leader>fw", "<cmd>w<cr>", "Write")

-- Deleting buffers
local buffers = require("helpers.buffers")
nmap("<leader>db", buffers.delete_this, "Current buffer")
