local nmap = require("helpers.keys").nmap
local vmap = require("helpers.keys").vmap

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-github.nvim",
			"sharkdp/fd",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
		},
		config = function()
			local telescope = require("telescope")
			local builtins = require("telescope.builtin")
			local lga_actions = require("telescope-live-grep-args.actions")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					file_ignore_patterns = { "dist", "generated", "node_modules", "prisma/migrations" },
					path_display = { "filename_first" },
				},

				extensions = {
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
						mappings = { -- extend mappings
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
								-- freeze the current list and start a fuzzy search in the frozen list
								["<C-space>"] = actions.to_fuzzy_refine,
							},
						},
					},
				},
			})
			pcall(telescope.load_extension, "fzf")
			telescope.load_extension("ui-select")
			telescope.load_extension("gh")
			telescope.load_extension("chezmoi")
			telescope.load_extension("notify")
			telescope.load_extension("live_grep_args")
			-- Find files using Telescope command-line sugar.
			nmap("<leader>ff", builtins.find_files, "[F]ind [F]iles")
			nmap("<leader>fc", telescope.extensions.chezmoi.find_files, "[F]ind [C]hezmoi files")
			nmap("<leader>?", builtins.oldfiles, "[?] Find recently opened files")
			nmap("<leader>fr", builtins.resume, "[F]ind [R]esume")
			nmap("<leader>fb", builtins.buffers, "[F]ind [B]uffers")
			nmap("<leader>fq", builtins.quickfix, "[F]ind [Q]uickfix")
			nmap("<leader>fs", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				builtins.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					previewer = false,
				}))
			end, "[F]ind [S]ymbols")
			nmap("<leader>fh", builtins.help_tags, "[F]ind [H]elp")
			nmap("<leader>f", builtins.builtin, "[F]ind something")
			nmap("gd", builtins.lsp_definitions, "[G]oto [D]efinition")
			nmap("gr", builtins.lsp_references, "[G]oto [R]eferences")
			vmap("<leader>fg", function()
				require("telescope-live-grep-args.shortcuts").grep_visual_selection()
			end, "[F]ind [G]rep")
			nmap("<leader>fg", function()
				require("telescope").extensions.live_grep_args.live_grep_args()
			end, "[F]ind [G]rep")
		end,
	},
	{
		"nvim-telescope/telescope-symbols.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
}
