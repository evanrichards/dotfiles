-- Handle plugins with lazy.nvim
require("core.lazy")
require("core.options")
require("core.keymaps")

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
-- Function to get visual selection
function _G.get_visual_selection()
	local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
	if start_row ~= end_row then
		return ""
	end
	local line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1]
	return line:sub(start_col, end_col)
end

-- Function to open a URL
function _G.open_url()
	local selection = _G.get_visual_selection()
	local url = "https://go/qid/" .. selection
	vim.fn.jobstart({ "open", url })
end

local function generate_uuid()
	vim.fn.system("uuidgen|sed 's/.*/&/'|tr '[A-Z]' '[a-z]' | pbcopy")
	vim.fn.execute('normal! "+p')
end

vim.api.nvim_create_user_command("GenerateUUID", generate_uuid, {})

-- Map visual mode command to open url
vim.api.nvim_set_keymap("v", "<leader>u", ":lua open_url()<CR>", { noremap = true, silent = true })
