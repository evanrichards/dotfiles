return {
	{
		"lewis6991/gitsigns.nvim",
		opts = function(_, opts)
			opts.current_line_blame = true
		end,
	},
	"tpope/vim-fugitive",
	{
		"ruifm/gitlinker.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
    lazy = false,
	},
}
