require("nvim-lsp-installer").setup({
	automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
	ui = {
		icons = {
			server_installed = "✓",
			server_pending = "➜",
			server_uninstalled = "✗",
		},
	},
})

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
local on_attach = function(_, buffer)
	local opts = { noremap = true, silent = true, buffer = buffer }
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set("n", "gD", function()
		vim.lsp.buf.declaration()
	end, opts)
	-- vim.keymap.set("n", "gd", function()
	-- 	vim.lsp.buf.definition()
	-- end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	-- vim.keymap.set("n", "gi", function()
	-- 	vim.lsp.buf.implementation()
	-- end, opts)
	vim.keymap.set("n", "<C-k>", function()
		vim.lsp.buf.signature_help()
	end, opts)
	vim.keymap.set("n", "<leader>wa", function()
		vim.lsp.buf.add_workspace_folder()
	end, opts)
	vim.keymap.set("n", "<space>wl", function()
		vim.lsp.buf.remove_workspace_folder()
	end, opts)
	vim.keymap.set("n", "<space>wl", function()
		vim.inspect(vim.lsp.buf.list_workspace_folders())
	end, opts)
	-- vim.keymap.set("n", "<leader>D", function()
	-- 	vim.lsp.buf.type_definition()
	-- end, opts)
	vim.keymap.set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	-- vim.keymap.set("n", "gr", function()
	-- 	vim.lsp.buf.references()
	-- end, opts)
	-- vim.keymap.set("n", "<leader>f", function()
	-- 	vim.lsp.buf.formatting()
	-- end, opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
	"bashls",
	"cssls",
	"eslint",
	"graphql",
	"html",
	"jsonls",
	"prismals",
	"pyright",
	"marksman",
	-- this requires project files to start, i mostly wanted it for notes files
	-- and diary files so not very useful.
	-- "remark_ls",
	"rust_analyzer",
	"sumneko_lua",
	"tsserver",
	"vimls",
	"yamlls",
}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

require("lspconfig").tsserver.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		preferences = {
			importModuleSpecifierPreference = "non-relative",
		},
	},
})

require("lspconfig").tsserver.setup({
	init_options = { preferences = { importModuleSpecifierPreference = "non-relative" } },
})

require("lspconfig").sumneko_lua.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "use" },
			},
		},
	},
})
