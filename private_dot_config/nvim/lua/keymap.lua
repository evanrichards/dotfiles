local map = function(mode, keys, func, desc, bufnr)
	vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
end

local nmap = function(keys, func, desc, bufnr)
	map("n", keys, func, desc, bufnr)
end

local vmap = function(keys, func, desc, bufnr)
	map("v", keys, func, desc, bufnr)
end

local imap = function(keys, func, desc, bufnr)
	map("i", keys, func, desc, bufnr)
end

return {
	nmap = nmap,
	imap = imap,
	vmap = vmap,
	map = map,
}
