local imap = require("helpers.keys").imap
local function generate_uuid()
	local uuid = vim.fn.system("uuidgen | tr '[:upper:]' '[:lower:]'")
	uuid = string.gsub(uuid, "\n", "") -- Remove trailing newline
	vim.api.nvim_put({ uuid }, "", false, true)
end

vim.api.nvim_create_user_command("GenerateUUID", generate_uuid, {})

imap("<C-u><C-u>", generate_uuid, "Generate UUID")
