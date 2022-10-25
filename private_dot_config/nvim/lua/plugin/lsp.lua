-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local dopts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", function()
	vim.diagnostic.open_float()
end, dopts)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.goto_prev()
end, dopts)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.goto_next()
end, dopts)
vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist()
end, dopts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local opts = {
	on_attach = require("plugin.lsp.lsp-config").on_attach,
	capabilities = require("plugin.lsp.lsp-config").capabilities,
}
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason_lspconfig.setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- Default handler (optional)
		lspconfig[server_name].setup({
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
		})
	end,

	["sumneko_lua"] = function()
		lspconfig.sumneko_lua.setup({
			capabilities = opts.capabilities,
			on_attach = opts.on_attach,
			settings = { Lua = { diagnostics = { globals = { "vim", "use" } } } },
		})
	end,

	["tsserver"] = function()
		require("typescript").setup({
			server = {
				capabilities = opts.capabilities,
				on_attach = opts.on_attach,
				init_options = {
					preferences = {
						importModuleSpecifierPreference = "non-relative",
						noUnusedParameters = false,
					},
				},
			},
		})
	end,
})

vim.api.nvim_create_user_command("LspRelative", function()
	lspconfig.tsserver.setup({
		init_options = {
			preferences = { importModuleSpecifierPreference = "non-relative" },
		},
	})
end, {})
