local lsp = require("lsp-zero")
local cmp = require("cmp")

lsp.preset("recommended")

lsp.set_preferences({
	set_lsp_keymaps = false,
	sign_icons = {},
})

lsp.configure("tsserver", {
	on_attach = function(client, bufnr)
		require("typescript").setup({
			server = {
				capabilities = opts.capabilities,
				on_attach = opts.on_attach,
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

lsp.on_attach(function(client, bufnr)
	local noremap = { buffer = bufnr, remap = false }
	local bind = vim.keymap.set
	bind("n", "<leader>e", function()
		vim.diagnostic.open_float()
	end, noremap)
	bind("n", "gD", vim.lsp.buf.declaration(), noremap)
	bind("n", "K", vim.lsp.buf.definition(), noremap)
	bind("n", "<C-k>", vim.lsp.buf.signature_help(), noremap)
	bind("n", "<leader>rn", vim.lsp.buf.rename(), noremap)
	bind("n", "<leader>ca", vim.lsp.buf.code_action(), noremap)
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

cmp.setup(cmp_config)

lsp.setup()
