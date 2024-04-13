return {
	"alker0/chezmoi.vim",
	lazy = false,
	init = function()
		-- This option is required.
		vim.g["chezmoi#use_tmp_buffer"] = true
	end,
}
