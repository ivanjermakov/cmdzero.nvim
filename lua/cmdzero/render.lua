local Popup = require("nui.popup")
local util = require("cmdzero.util")
local log = require("cmdzero.log")

local M = {}

---@class Popup
---@field mount function
---@field unmount function
---@field bufnr number

---@class State
---@field text string[]|nil
---@field popup Popup|nil
---@field active Message|nil
M.state = { text = nil, popup = nil, active = nil }

---@param message Message
---@return string[]
M.format = function(message)
    local msg = message.chunks[#message.chunks][2]
    return util.split(msg, "\n")
end

M.render = function(message)
    -- only clear with `msg_showmode` if active message is also `msg_showmode`
    if message.chunks == nil and message.event == "msg_showmode" and
        M.state.active ~= nil and M.state.active.event ~= "msg_showmode" then
        return
    end

    if message.chunks == nil and message.clear then
        M.clear()
        return
    end

    local text = M.format(message)
    if #text == 0 then return end

    if text == M.state.text then return end

    M.clear()

    M.state.popup = Popup({
        enter = false,
        focusable = false,
        border = { style = "none", },
        relative = "editor",
        position = { row = vim.o.lines - #text, col = 0 },
        size = { width = #text[1], height = #text }
    })
    M.state.popup:mount()
    log.info("text", text)
    vim.api.nvim_buf_set_lines(M.state.popup.bufnr, 0, 1, false, text)

    M.state.active = message
    M.state.text = text
end

M.clear = function()
    if M.state.popup then
        M.state.popup:unmount()
        M.state.text = nil
        M.state.popup = nil
        M.state.active = nil
    end
end

return M
