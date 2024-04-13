return {
	"catppuccin/nvim",
	name = "catppuccin",
	opts = function()
		return {
			integrations = {
				cmp = true,
				gitsigns = true,
				lualine = true,
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
		}
	end,
	config = function()
		vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
		vim.cmd([[colorscheme catppuccin]])
	end,
}
