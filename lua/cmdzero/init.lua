local M = {}

function M.setup()
	require("cmdzero.config").setup()
	require("cmdzero.handlers").setup()
	require("cmdzero.ui").setup()
end

return M
