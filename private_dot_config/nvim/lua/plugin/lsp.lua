local lsp = require("lsp-zero")
local cmp = require("cmp")
local nmap = require("keymap").nmap

lsp.preset("recommended")

lsp.set_preferences({
	set_lsp_keymaps = false,
	sign_icons = {},
})

lsp.configure("tsserver", {
	on_attach = function()
		require("typescript").setup({
			server = {
				init_options = {
					preferences = {
						importModuleSpecifierPreference = "non-relative",
						noUnusedParameters = false,
					},
				},
			},
		})
	end,
})

lsp.on_attach(function(_, bufnr)
	nmap("<leader>e", vim.diagnostic.open_float, "Open [E]rrors under cursor", bufnr)
	nmap("K", vim.lsp.buf.hover, "Display definition", bufnr)
	nmap("<C-k>", vim.lsp.buf.signature_help, "Display signature", bufnr)
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame symbol", bufnr)
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", bufnr)
end)

local cmp_select = { behavior = cmp.SelectBehavior.Select }

lsp.setup_nvim_cmp(lsp.defaults.cmp_config({
	preselect = "none",
	completion = {
		completeopt = "menu,menuone,noinsert,noselect",
	},
	mapping = lsp.defaults.cmp_mappings({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	}),
}))

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

lsp.setup()
