return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = function()
			return {
				settings = {
					expose_as_code_action = "all",
					tsserver_plugins = {
						"@styled/typescript-styled-plugin",
					},
					tsserver_file_preferences = {
						quotePreference = "single",
						importModuleSpecifierPreference = "non-relative",
						noUnusedParameters = false,
						autoImportFileExcludePatterns = {
							"./**/node_modules/@aws-sdk/client-textract/**",
							"**/node_modules/@aws-sdk/client-textract/**",
						},
					},
				},
			}
		end,
	},
	{
		"dmmulroy/tsc.nvim",
		opts = function()
			return {
				auto_open_qflist = true,
				auto_close_qflist = false,
				bin_path = vim.fn.findfile("node_modules/.bin/tsc"),
				enable_progress_notifications = true,
				flags = {
					noEmit = true,
					project = function()
						return vim.fn.findfile("tsconfig.json")
					end,
				},
				hide_progress_notifications_from_history = true,
				spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
			}
		end,
	},
}
