local lsp = require("lsp-zero")
local cmp = require("cmp")
local nmap = require("keymap").nmap

lsp.set_preferences({
	suggest_lsp_servers = true,
	setup_servers_on_start = true,
	set_lsp_keymaps = true,
	configure_diagnostics = true,
	cmp_capabilities = true,
	manage_nvim_cmp = true,
	call_servers = "local",
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
	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame symbol", bufnr)
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", bufnr)
end)

local cmp_select = { behavior = cmp.SelectBehavior.Select }

local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
})
-- I want tab to be used by copilot, and have to manually select drop down items
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil
local cmp_config = lsp.defaults.cmp_config({ preselect = cmp.PreselectMode.None })
cmp_config["mapping"] = cmp_mappings
lsp.setup_nvim_cmp(cmp_config)

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
