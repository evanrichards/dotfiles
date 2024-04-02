vim.g.mapleader = " "
-- thinking of this a shared augroup across any autoformatting plugins, this is
-- the only place that clear should be true, the others just add on to it.
local nmap = require("keymap").nmap
local vmap = require("keymap").vmap
vim.notify("Loading plugins", "info", { title = "Neovim" })

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
vim.opt.errorformat = "%+A\\ %#%f\\ %#(%l\\\\\\,%c):\\ %m,%C%m"
vim.cmd("set makeprg=yarn\\ tsc")
-- if our filetype is typescript then we want to set errorformat
-- vim.cmd("autocmd FileType typescript setlocal errorformat=%+A %#%f %#(%l\\,%c): %m,%C%m")
-- and we want to set the makeprg
-- vim.cmd("autocmd FileType typescript setlocal makeprg=yarn\\ tsc\\ --noEmit")
-- Function to get visual selection
function _G.get_visual_selection()
	local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
	if start_row ~= end_row then
		return ""
	end
	local line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1]
	return line:sub(start_col, end_col)
end

-- Function to open a URL
function _G.open_url()
	local selection = _G.get_visual_selection()
	local url = "https://go/qid/" .. selection
	vim.fn.jobstart({ "open", url })
end

local function generate_uuid()
	vim.fn.system("uuidgen|sed 's/.*/&/'|tr '[A-Z]' '[a-z]' | pbcopy")
	vim.fn.execute('normal! "+p')
end

vim.api.nvim_create_user_command("GenerateUUID", generate_uuid, {})

-- Map visual mode command to open url
vim.api.nvim_set_keymap("v", "<leader>u", ":lua open_url()<CR>", { noremap = true, silent = true })
function _G.select_and_sort()
	vim.cmd("norm vi[")
	vim.cmd("'<,'>sort")
end

vim.api.nvim_set_keymap("n", "<leader>sa", ":lua select_and_sort()<CR>", { noremap = true, silent = true })
