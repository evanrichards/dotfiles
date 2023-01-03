local nmap = require("keymap").nmap
local telescope = require("telescope")
local builtins = require("telescope.builtin")
telescope.setup({
	defaults = {
		file_ignore_patterns = { "dist", "generated", "node_modules", "prisma/migrations" },
	},
})
pcall(telescope.load_extension, "fzf")
telescope.load_extension("ui-select")
telescope.load_extension("gh")
-- Find files using Telescope command-line sugar.
nmap("<leader>ff", builtins.find_files, "[F]ind [F]iles")

nmap("<leader>?", builtins.oldfiles, "[?] Find recently opened files")
nmap("<leader>fr", builtins.resume, "[F]ind [R]esume")
nmap("<leader>fg", builtins.live_grep, "[F]ind [G]rep")
nmap("<leader>fb", builtins.buffers, "[F]ind [B]uffers")
nmap("<leader>fs", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	builtins.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		previewer = false,
	}))
end, "[F]ind [S]ymbols")
nmap("<leader>fh", builtins.help_tags, "[F]ind [H]elp")
nmap("<leader>f", builtins.builtin, "[F]ind something")
nmap("gd", builtins.lsp_definitions, "[G]oto [D]efinition")
nmap("gr", builtins.lsp_references, "[G]oto [R]eferences")
