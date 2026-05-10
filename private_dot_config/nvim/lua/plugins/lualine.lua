-- Fancier statusline
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons", "catppuccin/nvim" },
	config = function()
		local function lsp_progress()
			local messages = vim.lsp.status()
			if #messages == 0 then
				return ""
			end
			local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
			local ms = vim.loop.hrtime() / 1000000
			local frame = math.floor(ms / 120) % #spinners
			return spinners[frame + 1]
		end
		local function recording_status()
			if vim.fn.reg_recording() ~= "" then
				return "🔴"
			end
			return ""
		end
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = require("catppuccin.utils.lualine")(),
				component_separators = "|",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = { "filename" },
				lualine_x = {
					lsp_progress,
					recording_status,
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
