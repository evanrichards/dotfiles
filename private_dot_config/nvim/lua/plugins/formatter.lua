local nmap = require("helpers.keys").nmap
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				python = { "isort", "black" },
				lua = { "stylua" },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettier" },
				json = { "prettierd", "prettier", stop_after_first = true },
				sql = { "pg_format" },
				sh = { "shfmt" },
				rust = { "rustfmt" },
				markdown = { "prettier" },
				go = { "gofmt" },
			},
			formatters = {
				rustfmt = {
					prepend_args = { "--edition=2021" },
				},
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		})
		nmap("<leader>af", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, "[A]uto [F]ormat")
	end,
}
