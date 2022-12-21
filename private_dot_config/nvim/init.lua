vim.g.mapleader = " "
-- thinking of this a shared augroup across any autoformatting plugins, this is
-- the only place that clear should be true, the others just add on to it.
local nmap = require("keymap").nmap
local vmap = require("keymap").vmap

-- this loads all my plugins, configures and initializes them.
require("plugin")
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- global statusline
vim.opt.laststatus = 3

vim.opt.splitbelow = true
vim.opt.splitright = true

nmap("<C-Left>", ":vertical resize +3<CR>", "Increase width of current buffer")
nmap("<C-Right>", ":vertical resize -3<CR>", "Decrease width of current buffer")
nmap("<C-Up>", ":resize +3<CR>", "Increase height of current buffer")
nmap("<C-Down>", ":resize -3<CR>", "Decrease height of current buffer")

nmap("<leader>af", ":FormatWrite<CR>", "[A]uto [F]ormat")
-- in visual mode, when you indent a block, go back into visual mode
vmap("<", "<gv")
vmap(">", ">gv")

vim.opt.visualbell = true
vim.opt.errorbells = false
vim.opt.wrap = true
-- TODO: these should change to 88 for python files
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
nmap("<leader>/", ":nohlsearch<CR>")

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
