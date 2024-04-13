return {
	{
		"alker0/chezmoi.vim",
		lazy = false,
		init = function()
			-- This option is required.
			vim.g["chezmoi#use_tmp_buffer"] = true
		end,
	},
	{
		"xvzc/chezmoi.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("chezmoi").setup({
				-- your configurations
			})
		end,
	},
}
