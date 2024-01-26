local Popup = require("nui.popup")
local log = require("cmdzero.log")

local M = {}

M.renderer = { popup = nil }

M.format = function(message)
    log.warn("format", message.chunks)
    return message.chunks[#message.chunks][2]
end

M.render = function(message)
    log.warn("render", message)

    M.clear()

    if message.chunks == nil then return end
    local text = M.format(message)
    if #text == 0 then return end

    M.renderer.popup = Popup({
        enter = false,
        focusable = false,
        border = { style = "none", },
        relative = "editor",
        position = { row = "100%", col = 0 },
        size = { width = #text, height = 1, }
    })
    M.renderer.popup:mount()
    vim.api.nvim_buf_set_lines(M.renderer.popup.bufnr, 0, 1, false, { text })
end

M.clear = function()
    if M.renderer.popup then
        log.warn("clear")
        M.renderer.popup:unmount()
    end
end

return M
