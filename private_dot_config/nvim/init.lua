vim.g.mapleader = " "
-- thinking of this a shared augroup across any autoformatting plugins, this is
-- the only place that clear should be true, the others just add on to it.
local autoformatAugroup = vim.api.nvim_create_augroup("autoformat_settings", { clear = true })

-- this loads all my plugins, configures and initializes them.
require("plugin")
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- in visual mode, when you indent a block, go back into visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.opt.number = true
vim.opt.relativenumber = true
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

vim.opt.scrolloff = 8
vim.opt.backspace = { "indent", "eol", "start" }

vim.keymap.set({ "i", "n" }, "<up>", "<nop>")
vim.keymap.set({ "i", "n" }, "<down>", "<nop>")
vim.keymap.set({ "i", "n" }, "<left>", "<nop>")
vim.keymap.set({ "i", "n" }, "<right>", "<nop>")

-- clear search highlighting with <space>+</>
vim.keymap.set({ "n" }, "<leader>/", ":nohlsearch<CR>")

-- delete trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = autoformatAugroup,
	command = ":%s/\\s\\+$//e",
})
