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

local telekastenAugroup = vim.api.nvim_create_augroup("telekasten_augroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "telekasten",
	group = telekastenAugroup,
	callback = function()
		vim.keymap.set({ "n" }, "<leader>ch", function()
			require("telekasten").toggle_todo()
		end)
	end,
})
