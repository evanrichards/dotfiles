-- move this to neoformat file in plugins
local autoformatAugroup = vim.api.nvim_create_augroup("autoformat_settings", { clear = false })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.ts",
	group = autoformatAugroup,
	command = "Neoformat",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.lua",
	group = autoformatAugroup,
	command = "Neoformat",
})

vim.g.neoformat_try_node_exe = 1
