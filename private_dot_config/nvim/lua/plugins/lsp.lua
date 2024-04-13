local lsp_map = require("helpers.keys").lsp_map

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				event = "LspAttach",
			},
			"folke/neodev.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Set up Mason before anything else
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pylsp",
				},
				automatic_installation = true,
			})

			-- Neodev setup before LSP config
			require("neodev").setup()

			-- Turn on LSP status information
			require("fidget").setup()

			-- Set up cool signs for diagnostics
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- Diagnostic config
			local config = {
				virtual_text = false,
				signs = {
					active = signs,
				},
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			}
			vim.diagnostic.config(config)

			-- This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(client, bufnr)
				local builtins = require("telescope.builtin")
				lsp_map("<leader>e", vim.diagnostic.open_float, bufnr, "Show diagnostics")
				lsp_map("<leader>rn", vim.lsp.buf.rename, bufnr, "Rename symbol")
				lsp_map("<leader>ca", vim.lsp.buf.code_action, bufnr, "Code action")
				lsp_map("gd", builtins.lsp_definitions, bufnr, "Goto Definition")
				lsp_map("gr", builtins.lsp_references, bufnr, "Goto References")
				lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
			end

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			local lspconfig = require("lspconfig")

			-- Lua
			lspconfig["lua_ls"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})

			-- -- Python
			-- lspconfig["pylsp"].setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	settings = {
			-- 		pylsp = {
			-- 			plugins = {
			-- 				flake8 = {
			-- 					enabled = true,
			-- 					maxLineLength = 88, -- Black's line length
			-- 				},
			-- 				-- Disable plugins overlapping with flake8
			-- 				pycodestyle = {
			-- 					enabled = false,
			-- 				},
			-- 				mccabe = {
			-- 					enabled = false,
			-- 				},
			-- 				pyflakes = {
			-- 					enabled = false,
			-- 				},
			-- 				-- Use Black as the formatter
			-- 				autopep8 = {
			-- 					enabled = false,
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- })
		end,
	},
}
