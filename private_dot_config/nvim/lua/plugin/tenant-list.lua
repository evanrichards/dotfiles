local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local cached_tenants = nil
local cache_dir = vim.fn.stdpath("data") .. "/tenant_cache/"
vim.fn.mkdir(cache_dir, "p")
local cache_threshold = 60 * 60 * 24 -- 1 day in seconds

local function get_cache_file()
	return cache_dir .. os.date("%Y%m%d") .. "_tenants.lua"
end

local function load_tenants_from_cache()
	local cache_file = get_cache_file()
	local file = io.open(cache_file, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return load(content)()
	end
	return nil
end

local function save_tenants_to_cache(tenants)
	local cache_file = get_cache_file()
	local file = io.open(cache_file, "w")
	if file then
		file:write("return " .. vim.inspect(tenants))
		file:close()
	end
end

local function is_cache_expired()
	local cache_file = get_cache_file()
	local attr = vim.loop.fs_stat(cache_file)
	if attr then
		local age = os.time() - attr.mtime.sec
		return age > cache_threshold
	end
	-- delete the expired cache file if it exists
	vim.fn.delete(cache_file)
	return true
end

local function get_tenants()
	if cached_tenants and not is_cache_expired() then
		return cached_tenants
	end

	cached_tenants = load_tenants_from_cache()
	if cached_tenants and not is_cache_expired() then
		return cached_tenants
	end

	local tenants = {}
	local query = "select name, qid from tenant;"
	local result = vim.fn.systemlist('yarn prod:psql -c "' .. query .. '"')

	for i = 3, #result - 2 do
		local name, qid = string.match(result[i], "^%s*(.-)%s*|%s*(.-)%s*$")
		table.insert(tenants, { name = name, qid = qid })
	end

	save_tenants_to_cache(tenants)
	cached_tenants = tenants
	return tenants
end

local function tenant_list(opts)
	opts = opts or {}
	local tenants = get_tenants()

	pickers
		.new(opts, {
			prompt_title = "Tenants",
			finder = finders.new_table({
				results = tenants,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.name,
						ordinal = entry.name,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry().value
					actions.close(prompt_bufnr)
					vim.api.nvim_put({ "'" .. selection.qid .. "'" }, "", true, true)
				end)
				return true
			end,
		})
		:find()
end

return {
	tenant_list = tenant_list,
}
