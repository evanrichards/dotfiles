local nmap = require("helpers.keys").nmap
return {
	"mhartington/formatter.nvim",
	config = function()
		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.ERROR,

			filetype = {
				python = {
					require("formatter.filetypes.python").black,
					require("formatter.filetypes.python").isort,
				},
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				typescript = {
					require("formatter.filetypes.typescript").prettierd,
				},
				yaml = {
					require("formatter.filetypes.yaml").pyyaml,
				},
				typescriptreact = {
					require("formatter.filetypes.typescriptreact").prettierd,
				},
				sql = {
					require("formatter.filetypes.sql").pgformat,
				},
				sh = {
					require("formatter.filetypes.sh").shfmt,
				},
				rust = {
					{
						exe = "rustfmt",
						args = { "--edition=2021" },
						stdin = true,
					},
				},
				markdown = {
					require("formatter.filetypes.markdown").prettier,
				},
				["*"] = {
					-- "formatter.filetypes.any" defines default configurations for any
					-- filetype
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		})
		nmap("<leader>af", ":FormatWrite<CR>", "[A]uto [F]ormat")
	end,
}
