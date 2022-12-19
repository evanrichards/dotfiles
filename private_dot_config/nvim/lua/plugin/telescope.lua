local telescope = require("telescope")
local builtins = require("telescope.builtin")
telescope.setup({
	defaults = {
		file_ignore_patterns = { "dist", "generated", "node_modules", "prisma/migrations" },
	},
})
telescope.load_extension("ui-select")
telescope.load_extension("gh")

local nmap = function(keys, func, desc)
	vim.keymap.set("n", keys, func, { desc = desc })
end
-- Find files using Telescope command-line sugar.
nmap("<leader>ff", builtins.find_files, "[F]ind [F]iles")
nmap("<leader>fr", builtins.resume, "[F]ind [R]esume")
nmap("<leader>fg", builtins.live_grep, "[F]ind [G]rep")
nmap("<leader>fb", builtins.buffers, "[F]ind [B]uffers")
nmap("<leader>fs", builtins.lsp_document_symbols, "[F]ind [S]ymbols")
nmap("<leader>fh", builtins.help_tags, "[F]ind [H]elp")
nmap("<leader>f", builtins.builtin, "[F]ind something")
nmap("gd", builtins.lsp_definitions, "[G]oto [D]efinition")
nmap("gr", builtins.lsp_references, "[G]oto [R] references")
