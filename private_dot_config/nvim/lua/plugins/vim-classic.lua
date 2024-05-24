return {
	"tpope/vim-sensible",
	"kylechui/nvim-surround",
	"stevearc/dressing.nvim",
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
}
