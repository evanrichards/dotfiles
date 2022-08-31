local on_attach = function(_, buffer)
	local opts = { noremap = true, silent = true, buffer = buffer }
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vim.keymap.set("n", "gD", function()
		vim.lsp.buf.declaration()
	end, opts)
	-- using telescope for this
	-- vim.keymap.set("n", "gd", function()
	-- 	vim.lsp.buf.definition()
	-- end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	-- using telescope for this
	-- vim.keymap.set("n", "gi", function()
	-- 	vim.lsp.buf.implementation()
	-- end, opts)
	vim.keymap.set("n", "<C-k>", function()
		vim.lsp.buf.signature_help()
	end, opts)
	-- vim.keymap.set("n", "<leader>wa",
	--                function() vim.lsp.buf.add_workspace_folder() end, opts)
	-- vim.keymap.set("n", "<space>wl",
	--                function() vim.lsp.buf.remove_workspace_folder() end, opts)
	-- vim.keymap.set("n", "<space>wl", function()
	--     vim.inspect(vim.lsp.buf.list_workspace_folders())
	-- end, opts)
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
	vim.keymap.set("n", "<leader>af", function()
		vim.lsp.buf.formatting()
	end, opts)
end
local cmp = require("cmp_nvim_lsp")

local capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
return { on_attach = on_attach, capabilities = capabilities }
