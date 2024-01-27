local M = {}

function M.setup()
    require("cmdzero.config").setup()
    require("cmdzero.queue").setup()
    require("cmdzero.ui").setup()
    vim.keymap.set("n", "<esc>", function()
        require("cmdzero.queue").queue({ event = "msg_clear" })
    end)
end

return M
