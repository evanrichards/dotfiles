require("typescript").setup()

local autoformatAugroup = vim.api.nvim_create_augroup("autoformat_settings", { clear = false })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.ts",
	group = autoformatAugroup,
	callback = function()
		local typescript = require("typescript")
		typescript.actions.removeUnused()
	end,
})
