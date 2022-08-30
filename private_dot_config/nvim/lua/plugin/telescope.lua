require("telescope").setup({
	defaults = {
		file_ignore_patterns = { "dist", "generated", "node_modules", "prisma/migrations" },
	},
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("frecency")
require("telescope").load_extension("gh")

-- Find files using Telescope command-line sugar.
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fr", ":Telescope frecency<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
vim.keymap.set("n", "<leader>f", ":Telescope<CR>")
vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>")
vim.keymap.set("n", "gi", ":Telescope lsp_implementations<CR>")
vim.keymap.set("n", "<leader>D", ":Telescope lsp_type_definitions<CR>")
vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")
