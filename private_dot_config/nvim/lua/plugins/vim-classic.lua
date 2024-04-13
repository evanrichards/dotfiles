return {
	"tpope/vim-sensible",
	"kylechui/nvim-surround",
	"stevearc/dressing.nvim",
	{
		"numToStr/Comment.nvim",
		lazy = false,
		opts = {},
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
}
