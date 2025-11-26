return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>af",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			desc = "[A]uto [F]ormat",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				python = { "isort", "black" },
				lua = { "stylua" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				yaml = { "prettier" },
				json = { "prettier" },
				sql = { "pg_format" },
				sh = { "shfmt" },
				rust = { "rustfmt" },
				markdown = { "prettier" },
				go = { "gofmt" },
			},
			formatters = {
				prettier = {
					command = "yarn",
					prepend_args = { "prettier" },
				},
				rustfmt = {
					prepend_args = { "--edition=2021" },
				},
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		})
	end,
}
