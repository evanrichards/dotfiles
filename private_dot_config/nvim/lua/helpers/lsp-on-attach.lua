local lsp_map = require("helpers.keys").lsp_map
local on_attach = function(_, bufnr)
	local builtins = require("telescope.builtin")
	lsp_map("<leader>e", vim.diagnostic.open_float, bufnr, "Show diagnostics")
	lsp_map("<leader>rn", vim.lsp.buf.rename, bufnr, "Rename symbol")
	lsp_map("<leader>ca", vim.lsp.buf.code_action, bufnr, "Code action")
	lsp_map("gd", builtins.lsp_definitions, bufnr, "Goto Definition")
	lsp_map("gr", builtins.lsp_references, bufnr, "Goto References")
	lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
end

return on_attach
