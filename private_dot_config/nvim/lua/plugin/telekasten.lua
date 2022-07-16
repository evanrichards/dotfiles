local tk = require("telekasten")

vim.keymap.set({ "n", "v" }, "<leader>zf", function()
	tk.find_notes()
end)
-- telescope style
vim.keymap.set({ "n", "v" }, "<leader>fz", function()
	tk.find_notes()
end)
vim.keymap.set({ "n", "v" }, "<leader>zd", function()
	tk.find_daily_notes()
end)
vim.keymap.set({ "n", "v" }, "<leader>zg", function()
	tk.search_notes()
end)
vim.keymap.set({ "n", "v" }, "<leader>zt", function()
	tk.goto_today()
end)
vim.keymap.set({ "n", "v" }, "<leader>zn", function()
	tk.new_note()
end)
vim.keymap.set({ "n", "v" }, "<leader>zN", function()
	tk.new_templated_note()
end)

--kk on hesitation, bring up the panel

vim.keymap.set({ "n", "v" }, "<leader>z", function()
	tk.panel()
end)

local telekastenAugroup = vim.api.nvim_create_augroup("telekasten_augroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = telekastenAugroup,
	callback = function(p)
		vim.keymap.set({ "n" }, "<leader>zt", function()
			tk.toggle_todo()
		end, { buffer = p.buf })
		vim.keymap.set({ "i" }, "ztt", function()
			tk.toggle_todo({ i = true })
		end, { buffer = p.buf })
		vim.keymap.set({ "n" }, "<leader>zz", function()
			tk.follow_link()
		end, { buffer = p.buf })
		vim.keymap.set({ "n" }, "<leader>zz", function()
			tk.follow_link()
		end, { buffer = p.buf })
		vim.keymap.set({ "n" }, "<leader>zb", function()
			tk.show_backlinks()
		end, { buffer = p.buf })
		vim.keymap.set({ "n" }, "<leader>zF", function()
			tk.find_friends()
		end, { buffer = p.buf })
		vim.keymap.set({ "n" }, "<leader>za", function()
			tk.show_tags()
		end, { buffer = p.buf })
		vim.keymap.set({ "n" }, "<leader>#", function()
			tk.show_tags()
		end, { buffer = p.buf })
		vim.keymap.set({ "i" }, "zaa", function()
			tk.show_tags({ i = true })
		end, { buffer = p.buf })
		vim.keymap.set({ "i" }, "z##", function()
			tk.show_tags({ i = true })
		end, { buffer = p.buf })
		vim.keymap.set({ "n" }, "<leader>zr", function()
			tk.rename_note()
		end, { buffer = p.buf })
		vim.keymap.set({ "n" }, "<leader>[", function()
			tk.insert_link()
		end, { buffer = p.buf })
		vim.keymap.set({ "i" }, "z[[", function()
			tk.insert_link({ i = true })
		end, { buffer = p.buf })
	end,
})

local home = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes")

return tk.setup({
	home = home,
	take_over_my_home = true,
	auto_set_filetype = true,
	dailies = home .. "/" .. "daily",
	weeklies = home .. "/" .. "weekly",
	templates = home .. "/" .. "templates",
	extension = ".md",
	new_note_filename = "title",
	follow_creates_nonexisting = true,
	dailies_create_nonexisting = true,
	weeklies_create_nonexisting = true,
	template_new_note = home .. "/" .. "templates/standard-note.md",
	template_new_daily = home .. "/" .. "templates/daily.md",
	template_new_weekly = home .. "/" .. "templates/weekly.md",
	journal_auto_open = true,
	image_link_style = "wiki",
	sort = "filename",
	plug_into_calendar = false,
	tag_notation = "#tag",
	rename_update_links = true,
})
