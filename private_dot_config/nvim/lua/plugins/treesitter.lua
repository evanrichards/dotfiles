return {
	{
		"nvim-treesitter/nvim-treesitter",

		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },

		build = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "vimdoc", "vim" },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		requires = { "nvim-treesitter/nvim-treesitter" },
		opts = function(_, opts)
			opts.enable = true
			opts.max_lines = 3
			opts.patterns = {
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
			}
		end,
	},
	{
		"nvim-treesitter/playground",
		requires = { "nvim-treesitter/nvim-treesitter" },
	},
}
