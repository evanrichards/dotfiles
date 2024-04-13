local lsp_map = require("helpers.keys").lsp_map
return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(_, bufnr)
				local builtins = require("telescope.builtin")
				lsp_map("<leader>e", vim.diagnostic.open_float, bufnr, "Show diagnostics")
				lsp_map("<leader>rn", vim.lsp.buf.rename, bufnr, "Rename symbol")
				lsp_map("<leader>ca", vim.lsp.buf.code_action, bufnr, "Code action")
				lsp_map("gd", builtins.lsp_definitions, bufnr, "Goto Definition")
				lsp_map("gr", builtins.lsp_references, bufnr, "Goto References")
				lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
			end
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			require("typescript-tools").setup({
				on_attach = on_attach,
				capabilities = capabilities,
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
			})
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
