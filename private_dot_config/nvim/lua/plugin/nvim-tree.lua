local nmap = require("keymap").nmap
local api = require("nvim-tree.api")
require("nvim-tree").setup({
	view = {
		width = 100,
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
})

nmap("<C-n>", api.tree.toggle, "Toggle filetree")
nmap("<leader>tr", api.tree.reload, "Refresh tree")
nmap("<leader>tt", function()
	api.tree.toggle(true)
end, "Find current file in tree")
