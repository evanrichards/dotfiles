return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,

		dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" } },

		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"c", "cpp", "go", "lua", "markdown", "markdown_inline", "python", "rust", "vimdoc", "vim",
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
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
}
