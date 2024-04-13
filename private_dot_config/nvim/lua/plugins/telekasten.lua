local nmap = require("helpers.keys").nmap
local imap = require("helpers.keys").imap
local map = require("helpers.keys").map

return {
	"renerocksai/telekasten.nvim",
	config = function()
		local tk = require("telekasten")

		map({ "n", "v" }, "<leader>zf", tk.find_notes, "[Z]ettelkasten [F]ind")
		-- telescope style
		map({ "n", "v" }, "<leader>fz", tk.find_notes, "[F]ind [Z]ettelkasten")
		map({ "n", "v" }, "<leader>zd", tk.find_daily_notes, "[Z]ettelkasten search [D]ailies")
		map({ "n", "v" }, "<leader>zg", tk.search_notes, "[Z]ettelkasten [G]oto note...")
		map({ "n", "v" }, "<leader>zt", tk.goto_today, "[Z]ettelkasten [T]oday's Note")
		map({ "n", "v" }, "<leader>zn", tk.new_note, "[Z]ettelkasten [N]ew note")
		map({ "n", "v" }, "<leader>zN", tk.new_templated_note, "[Z]ettelkasten templated [N]ote")

		--kk on hesitation, bring up the panel

		map({ "n", "v" }, "<leader>z", tk.panel, "[Z]ettelkasten panel")

		local telekastenAugroup = vim.api.nvim_create_augroup("telekasten_augroup", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			group = telekastenAugroup,
			callback = function(p)
				nmap("<leader>zt", tk.toggle_todo, "[Z]ettelkasten [T]odo toggle", p.buf)
				imap("ztt", function()
					tk.toggle_todo({ i = true })
				end, "[Z]ettelkasten [T]oggle [T]odo", p.buf)
				nmap("<leader>zz", tk.follow_link, "[Z]ettelkasten [Z]ip to link", p.buf)
				nmap("<leader>zb", tk.show_backlinks, "[Z]ettelkasten [B]acklink", p.buf)
				nmap("<leader>zF", tk.find_friends, "[Z]ettelkasten [F]ind [F]riends", p.buf)
				nmap("<leader>za", tk.show_tags, "[Z]ettelkasten t[A]gs", p.buf)
				imap("zaa", function()
					tk.show_tags({ i = true })
				end, "[Z]ettelkasten t[A]gs", p.buf)
				nmap("<leader>zr", tk.rename_note, "[Z]ettelkasten [R]ename note", p.buf)
				nmap("<leader>[", tk.insert_link, "[Z]ettelkasten insert link", p.buf)
				imap("z[[", function()
					tk.insert_link({ i = true })
				end, "[Z]ettelkasten insert link", p.buf)
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
	end,
}
