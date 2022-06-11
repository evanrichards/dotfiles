require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	-- https://github.com/tpope/vim-sensible
	use("tpope/vim-sensible")
	-- https://github.com/github/copilot.vim
	use("github/copilot.vim")
	-- code formatting
	use("sbdchd/neoformat")
	-- one dark theme
	use("navarasu/onedark.nvim")
	-- spell checking, use Zl for list of replacements, Zg to add, Zt to toggle
	use({ "kamykn/spelunker.vim", requires = { { "kamykn/popup-menu.nvim" } } })
	-- show git status on lines
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})
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
	use("nvim-telescope/telescope-ui-select.nvim")
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

	use("folke/trouble.nvim")

	use("jose-elias-alvarez/typescript.nvim")
	-- dashboard
	use("goolord/alpha-nvim")
	use({
		"ldelossa/gh.nvim",
		requires = { { "ldelossa/litee.nvim" } },
	})
	--[[ plugins to try but who has the time?

--]]

	-- github pr review module
end)
