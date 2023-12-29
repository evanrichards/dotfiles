require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	-- Lua
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
			require("catppuccin").setup()
			vim.cmd([[colorscheme catppuccin]])
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate | TSEnable highlight",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	})
	use("nvim-treesitter/playground")
	-- https://github.com/tpope/vim-sensible
	use("tpope/vim-sensible")
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})
	-- https://github.com/github/copilot.vim
	use("github/copilot.vim")
	-- show git status on lines
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})
		end,
	})
	-- Git support
	use("tpope/vim-fugitive")
	-- this updates inputs and pickers to be good looking
	use("stevearc/dressing.nvim")
	-- LSP
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- Useful status updates for LSP
			"j-hui/fidget.nvim",
			-- LSP Support

			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-cmdline" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			require("plugin.lsp")
		end,
	})
	-- needed for telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-github.nvim",
			"sharkdp/fd",
			"kyazdani42/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
			{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
		},
		config = function()
			require("plugin.telescope")
		end,
	})
	use({
		"nvim-telescope/telescope-symbols.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
	})
	-- statusline stuff
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			local function recordingStatus()
				if vim.fn.reg_recording() ~= "" then
					return "🔴"
				end
				return ""
			end
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					component_separators = "|",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { { recordingStatus }, "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "filename" },
					lualine_x = { require("wpm").wpm, require("wpm").historic_graph, "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
		requires = { "kyazdani42/nvim-web-devicons" },
	})
	use({
		"jose-elias-alvarez/typescript.nvim",
	})
	-- nice override of the vim.notify function
	use({
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	})
	-- gcc or gc[move] to toggle comments
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"renerocksai/telekasten.nvim",
		config = function()
			require("plugin.telekasten")
		end,
	})
	use({
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup()
		end,
	})
	use({
		"ruifm/gitlinker.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("gitlinker").setup()
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter-context",
		requires = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 3,
				patterns = {
					default = {
						"class",
						"function",
						"method",
						"for",
						"while",
						"if",
						"switch",
						"case",
					},
				},
			})
		end,
	})
	use({
		"mhartington/formatter.nvim",
		config = function()
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.ERROR,

				filetype = {
					python = {
						require("formatter.filetypes.python").black,
						require("formatter.filetypes.python").isort,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					typescript = {
						require("formatter.filetypes.typescript").prettierd,
						-- require("formatter.filetypes.typescript").eslint_d,
					},
					yaml = {
						require("formatter.filetypes.yaml").pyyaml,
					},
					typescriptreact = {
						require("formatter.filetypes.typescriptreact").prettierd,
					},
					sql = {
						require("formatter.filetypes.sql").pgformat,
					},
					sh = {
						require("formatter.filetypes.sh").shfmt,
					},
					rust = {
						{
							exe = "rustfmt",
							args = { "--edition=2021" },
							stdin = true,
						},
					},
					markdown = {
						require("formatter.filetypes.markdown").prettier,
					},
					["*"] = {
						-- "formatter.filetypes.any" defines default configurations for any
						-- filetype
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
		end,
	})
	-- Lua
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({})
			require("keymap").nmap("<leader>xx", "<cmd>TroubleToggle<cr>")
		end,
	})
	-- Packer
	use({
		"dpayne/CodeGPT.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
		},
	})
	use({
		"jcdickinson/wpm.nvim",
		config = function()
			require("wpm").setup({})
		end,
	})
	use({
		"dmmulroy/tsc.nvim",
		config = function()
			require("tsc").setup({
				auto_open_qflist = true,
				auto_close_qflist = false,
				bin_path = vim.fn.findfile("node_modules/.bin/tsc"),
				enable_progress_notifications = true,
				flags = {
					noEmit = true,
					project = function()
						return vim.fn.findfile("tsconfig.json")
					end,
				},
				hide_progress_notifications_from_history = true,
				spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
			})
		end,
		requires = {
			"rcarriga/nvim-notify",
		},
	})
	use({
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	})
end)
