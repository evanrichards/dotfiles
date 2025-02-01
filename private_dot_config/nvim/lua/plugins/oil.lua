local nmap = require("helpers.keys").nmap
return {
	"stevearc/oil.nvim",
	opts = function()
		nmap("-", "<CMD>Oil<CR>", "Open file in parent directory")
		return {
			lsp_file_methods = {
				-- Enable or disable LSP file operations
				enabled = true,
				-- Time to wait for LSP file operations to complete before skipping
				timeout_ms = 10000,
				-- Set to true to autosave buffers that are updated with LSP willRenameFiles
				-- Set to "unmodified" to only save unmodified buffers
				autosave_changes = false,
			},
		}
	end,
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
}
