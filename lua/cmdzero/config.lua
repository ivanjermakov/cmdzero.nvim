local M = {}

M.ns = vim.api.nvim_create_namespace("cmdzero")

---@class Config
M.defaults = {
}

--- @type Config
M.options = {}

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

return M
