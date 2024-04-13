local nmap = require("keymap").nmap
return {
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			-- Useful status updates for LSP
			"j-hui/fidget.nvim",
			-- LSP Support

			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-cmdline" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			local lsp = require("lsp-zero")
			lsp.extend_lspconfig()
			lsp.on_attach(function(_, bufnr)
				lsp.default_keymaps({ buffer = bufnr })
				nmap("<leader>e", vim.diagnostic.open_float, "Show diagnostics", bufnr)
				nmap("K", vim.lsp.buf.hover, "Display hover", bufnr)
				nmap("<C-k>", vim.lsp.buf.signature_help, "Display signature", bufnr)
				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame symbol", bufnr)
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", bufnr)
			end)

			lsp.set_preferences({
				suggest_lsp_servers = true,
				setup_servers_on_start = true,
				-- manage my own keymaps here for now because i want to use telescope for
				-- some of the lsp stuff
				set_lsp_keymaps = false,
				configure_diagnostics = true,
				cmp_capabilities = true,
				manage_nvim_cmp = true,
				call_servers = "local",
				sign_icons = {},
			})
			lsp.extend_cmp()
			local cmp = require("cmp")

			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			local cmp_mappings = lsp.defaults.cmp_mappings({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			})
			-- print cmp_mappings
			-- I want tab to be used by copilot, and have to manually select drop down items
			cmp_mappings["<Tab>"] = nil
			cmp_mappings["<S-Tab>"] = nil
			local cmp_config = lsp.defaults.cmp_config()
			cmp_config["mapping"] = cmp_mappings
			cmp_config["preselect"] = "none"
			cmp_config["completion"] = {
				completeopt = "menu,menuone,noinsert,noselect",
			}

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})

			cmp.setup({
				mapping = cmp_mappings,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"VonHeikemen/lsp-zero.nvim",
		},
		config = function()
			local lsp = require("lsp-zero")
			lsp.extend_lspconfig()
			require("mason").setup()
			require("mason-lspconfig").setup({
				handlers = {
					lsp.default_setup,
				},
			})
		end,
	},
}
