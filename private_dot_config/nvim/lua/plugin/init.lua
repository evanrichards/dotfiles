require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("sheerun/vim-polyglot")
	-- https://github.com/tpope/vim-sensible
	use("tpope/vim-sensible")
	-- https://github.com/github/copilot.vim
	use("github/copilot.vim")
	-- code formatting
	use({
		"sbdchd/neoformat",
		config = function()
			require("plugin.neoformat")
		end,
	})
	-- one dark theme
	use({
		"navarasu/onedark.nvim",
		config = function()
			--options here are dark, darker, cool, deep, warm, warmer
			require("onedark").setup({
				style = "darker",
			})
			require("onedark").load()
		end,
	})
	-- spell checking, use Zl for list of replacements, Zg to add, Zt to toggle
	use({ "kamykn/spelunker.vim", requires = { "kamykn/popup-menu.nvim" } })
	-- show git status on lines
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})
	-- Git support
	use("tpope/vim-fugitive")
	-- Github support, :Gbrowse and <C-X><C-O> for omnicomplete
	use("tpope/vim-rhubarb")
	-- navigate tmux panes with <C-movement> keys
	use("christoomey/vim-tmux-navigator")
	-- needed for telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			"nvim-telescope/telescope-fzf-native.nvim",
			"sharkdp/fd",
			"kyazdani42/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
			{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
		},
		config = function()
			require("plugin.telescope")
		end,
	})
	-- this updates inputs and pickers to be good looking
	use("stevearc/dressing.nvim")
	-- LSP
	use({
		"neovim/nvim-lspconfig",
		requires = { "williamboman/nvim-lsp-installer" },
		config = function()
			require("plugin.lsp")
		end,
	})
	-- auto-complete
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
		},
		config = function()
			require("plugin.nvim-cmp")
		end,
	})

	-- statusline stuff
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup()
		end,
		requires = { "kyazdani42/nvim-web-devicons" },
	})
	-- file explorer
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("plugin.nvim-tree")
		end,
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	use({
		"folke/trouble.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("plugin.trouble")
		end,
	})

	use({
		"jose-elias-alvarez/typescript.nvim",
		config = function()
			require("plugin.typescript")
		end,
	})
	-- dashboard
	use({
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
		requires = { "kyazdani42/nvim-web-devicons" },
	})
	-- github pr review module
	use({
		"ldelossa/gh.nvim",
		config = function()
			require("litee.gh").setup()
		end,
		requires = { {
			"ldelossa/litee.nvim",
			config = function()
				require("litee.lib").setup()
			end,
		} },
	})
	-- nice override of the vim.notify function
	use({
		"rcarriga/nvim-notify",
		run = function()
			vim.notify = require("notify")
		end,
	})
	-- easymotion style jumps, overrides s|S for in buffer jumps and gs for cross
	-- buffer
	use({
		"ggandor/leap.nvim",
		config = function()
			require("leap").set_default_keymaps()
		end,
		requires = { "tpope/vim-repeat" },
	})
	use("folke/lsp-colors.nvim")

	--[[ plugins to try but who has the time?
-- like a git status ui thing
TimUntersberger/neogit
-- make permalinks to the current line or lines in github
ruifm/gitlinker.nvim
-- change projects and get git info in status line
AckslD/nvim-gfold.lua
-- create diagrams in ascii
jbyuki/venn.nvim
https://github.com/vimwiki/vimwiki
--]]
end)