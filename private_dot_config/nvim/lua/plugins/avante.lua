return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	build = "make",
	opts = {
		mappings = {
			-- This defaults to `<leader>af`, which I use for autoformatting, setting
			-- to `nil` did not seem to disable the mapping. `ap` was unused.
			focus = "<leader>ap",
		},
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below is optional, make sure to setup it properly if you have lazy=true
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
