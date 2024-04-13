local vmap = require("helpers.keys").vmap

local function get_visual_selection()
	local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
	if start_row ~= end_row then
		return ""
	end
	local line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1]
	return line:sub(start_col, end_col)
end

-- Function to open a URL
local function open_url()
	local selection = get_visual_selection()
	local url = "https://go/qid/" .. selection
	vim.fn.jobstart({ "open", url })
end

-- Map visual mode command to open url
vmap("<leader>u", open_url, "Open qid as URL")
