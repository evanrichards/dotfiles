return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			integrations = {
				cmp = true,
				gitsigns = true,
				lualine = {},
				mason = true,
				notify = true,
				treesitter = true,
				treesitter_context = true,
				telescope = {
					enabled = true,
				},
				telekasten = true,
				which_key = true,
			},
		})
		vim.cmd([[colorscheme catppuccin]])
	end,
}
