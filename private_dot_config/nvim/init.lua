vim.g.mapleader = " "
-- thinking of this a shared augroup across any autoformatting plugins, this is
-- the only place that clear should be true, the others just add on to it.
local autoformatAugroup = vim.api.nvim_create_augroup("autoformat_settings", { clear = true })

-- this loads all my plugins, configures and initializes them.
require("plugin")
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- global statusline
vim.opt.laststatus = 3

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.keymap.set("n", "<C-Left>", ":vertical resize +3<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize -3<CR>")
vim.keymap.set("n", "<C-Up>", ":resize +3<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -3<CR>")

vim.keymap.set("n", "<leader>af", ":FormatWrite<CR>")
-- in visual mode, when you indent a block, go back into visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.wrap = true
vim.opt.textwidth = 79
vim.cmd("set colorcolumn=80")
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.spell = false
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.relativenumber = true
vim.opt.number = true
-- command line to be zero height
-- last status height
vim.opt.ls = 0
-- command height
vim.o.ch = 0


vim.opt.scrolloff = 8
vim.opt.backspace = { "indent", "eol", "start" }

-- clear search highlighting with <space>+</>
vim.keymap.set({ "n" }, "<leader>/", ":nohlsearch<CR>")

-- delete trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = autoformatAugroup,
	command = ":%s/\\s\\+$//e",
})

vim.keymap.set("n", "<leader>pp", function()
	require("treesorter").select()
end)
