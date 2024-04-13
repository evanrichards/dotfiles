
local map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

local lsp_map = function(lhs, rhs, bufnr, desc)
	vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end

local set_leader = function(key)
	vim.g.mapleader = key
	vim.g.maplocalleader = key
	map({ "n", "v" }, key, "<nop>")
end

return {
  map = map,
  lsp_map = lsp_map,
  set_leader = set_leader,
}
