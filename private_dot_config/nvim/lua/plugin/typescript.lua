require("typescript").setup()
-- move this to typescript file in plugins
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.ts",
	group = autoformatAugroup,
	callback = function()
		local typescript = require("typescript")
		typescript.actions.removeUnused()
	end,
})
