return {
	"tpope/vim-sensible",
	"kylechui/nvim-surround",
	"tpope/vim-fugitive",
	"stevearc/dressing.nvim",
	"numToStr/Comment.nvim",
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
}
