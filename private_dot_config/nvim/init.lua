vim.g.mapleader = " "

require("packer").startup(function()
	use("wbthomason/packer.nvim")
	-- https://github.com/tpope/vim-sensible
	use("tpope/vim-sensible")
	-- https://github.com/github/copilot.vim
	use("github/copilot.vim")
	-- code formatting
	use("google/vim-maktaba")
	use("google/vim-codefmt")
	use("sbdchd/neoformat")
	-- remove reflections
	use({ "dracula/vim", as = "dracula" })
	-- one dark theme
	use("navarasu/onedark.nvim")
	-- https://github.com/kamykn/spelunker.vim
	-- spell checking, use Zl for list of replacements, Zg to add, Zt to toggle
	use("kamykn/spelunker.vim")
	use("kamykn/popup-menu.nvim")
	-- kitty syntax highligting, way overkill
	use("fladson/vim-kitty")
	-- auto-close parens, quotes, and brackets; auto-formats with new lines
	-- this was annoying me so I disabled it
	-- use("cohama/lexima.vim")

	-- show git status on lines
	use("mhinz/vim-signify")
	-- wide ranging language support
	use("sheerun/vim-polyglot")
	-- Git support
	use("tpope/vim-fugitive")
	-- Github support, :Gbrowse and <C-X><C-O> for omnicomplete
	use("tpope/vim-rhubarb")
	-- navigate tmux panes with <C-movement> keys
	use("christoomey/vim-tmux-navigator")
	-- toggle and switch stuff with [ and ]
	use("tpope/vim-unimpaired")
	-- needed for telescope
	use("nvim-lua/plenary.nvim")
	use("BurntSushi/ripgrep")
	use("nvim-telescope/telescope-fzf-native.nvim")
	use("sharkdp/fd")
	use("kyazdani42/nvim-web-devicons")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-telescope/telescope.nvim")
	-- LSP
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")
	-- auto-complete
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")

	-- statusline stuff
	use("nvim-lualine/lualine.nvim")

	use("kyazdani42/nvim-tree.lua")
end)
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- turn on lualine statusline
require("lualine").setup()
require("nvim-tree").setup({})
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>")
vim.keymap.set("n", "<leader>c", ":NvimTreeFindFile<CR>")

--vim.cmd("colorscheme dracula")
--options here are dark, darker, cool, deep, warm, warmer
require("onedark").setup({
	style = "dark",
})
require("onedark").load()
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
vim.opt.backspace = "indent,eol,start"

vim.g.neoformat_try_node_exe = 1

vim.keymap.set({ "i", "n" }, "<up>", "<nop>")
vim.keymap.set({ "i", "n" }, "<down>", "<nop>")
vim.keymap.set({ "i", "n" }, "<left>", "<nop>")
vim.keymap.set({ "i", "n" }, "<right>", "<nop>")

-- clear search highlighting with <space>+<space>
vim.keymap.set({ "n" }, "<leader><space>", ":nohlsearch<CR>")

local augroup = vim.api.nvim_create_augroup("autoformat_settings", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.ts",
	group = augroup,
	command = "Neoformat",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.lua",
	group = augroup,
	command = "Neoformat",
})

-- format syntax highlight prisma files like typescript
vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
	pattern = "*.prisma",
	group = augroup,
	command = "set syntax=typescript",
})

-- delete trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = augroup,
	command = ":%s/\\s\\+$//e",
})

-- Find files using Telescope command-line sugar.
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")

require("nvim-lsp-installer").setup({
	automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗",
		},
	},
})

require("telescope").setup({
	defaults = {
		file_ignore_patterns = { "dist", "generated", "node_modules", "prisma/migrations" },
	},
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local dopts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float()
end, dopts)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.goto_prev()
end, dopts)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.goto_next()
end, dopts)
vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist()
end, dopts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, buffer)
	local opts = { noremap = true, silent = true, buffer = buffer }
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set("n", "gD", function()
		vim.lsp.buf.declaration()
	end, opts)
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "gi", function()
		vim.lsp.buf.implementation()
	end, opts)
	vim.keymap.set("n", "<C-k>", function()
		vim.lsp.buf.signature_help()
	end, opts)
	vim.keymap.set("n", "<leader>wa", function()
		vim.lsp.buf.add_workspace_folder()
	end, opts)
	vim.keymap.set("n", "<space>wl", function()
		vim.lsp.buf.remove_workspace_folder()
	end, opts)
	vim.keymap.set("n", "<space>wl", function()
		vim.inspect(vim.lsp.buf.list_workspace_folders())
	end, opts)
	vim.keymap.set("n", "<leader>D", function()
		vim.lsp.buf.type_definition()
	end, opts)
	vim.keymap.set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "gr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.formatting()
	end, opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
	"bashls",
	"cssls",
	"dockerls",
	"eslint",
	"grammarly",
	"graphql",
	"html",
	"jsonls",
	"prismals",
	"pyright",
	"remark_ls",
	"rust_analyzer",
	"sumneko_lua",
	"tsserver",
	"vimls",
	"yamlls",
}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

require("lspconfig").tsserver.setup({
	init_options = {
		preferences = {
			importModuleSpecifierPreference = "non-relative",
		},
	},
})

require("lspconfig").sumneko_lua.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "use" },
			},
		},
	},
})

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all"
	ensure_installed = { "python", "typescript", "vim", "lua" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing (for "all")
	ignore_install = {},

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = {},

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

-- Setup nvim-cmp.
local cmp = require("cmp")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
		-- { name = 'luasnip' }, -- For luasnip users.
		-- { name = 'ultisnips' }, -- For ultisnips users.
		-- { name = 'snippy' }, -- For snippy users.
	}, {
		{ name = "buffer" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
