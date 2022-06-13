vim.keymap.set({ "n", "v" }, "<leader>zf", function()
	require("telekasten").find_notes()
end)
-- telescope style
vim.keymap.set({ "n", "v" }, "<leader>fz", function()
	require("telekasten").find_notes()
end)
vim.keymap.set({ "n", "v" }, "<leader>zd", function()
	require("telekasten").find_daily_notes()
end)
vim.keymap.set({ "n", "v" }, "<leader>zg", function()
	require("telekasten").search_notes()
end)
vim.keymap.set({ "n", "v" }, "<leader>zz", function()
	require("telekasten").follow_link()
end)

--kk on hesitation, bring up the panel

vim.keymap.set({ "n", "v" }, "<leader>z", function()
	require("telekasten").panel()
end)
