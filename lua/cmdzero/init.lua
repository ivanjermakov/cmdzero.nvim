local config = require("cmdzero.config")

local M = {}

function M.setup()
    require("cmdzero.config").setup()
    require("cmdzero.queue").setup()
    require("cmdzero.ui").setup()
    -- on_key is used instead of normal vim.keymap.set because it interferes with another esc mappings
    -- (closing vim.lsp.buf.hover no longer works)
    vim.on_key(function(char)
        if char:byte() ~= 128 then return end
        require("cmdzero.queue").queue({ event = "msg_clear" })
    end, config.ns)
end

return M
