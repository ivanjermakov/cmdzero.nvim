local config = require("cmdzero.config")
local log = require("cmdzero.log")

local M = {}

M.attached = false

function M.attach()
    if M.attached then return end
    M.attached = true
    vim.ui_attach(config.ns, { ext_messages = true }, function(event, ...)
        M.handle(event, ...)
    end)
end

function M.detach()
    if M.attached then
        vim.ui_detach(config.ns)
        M.attached = false
    end
end

function M.setup()
    local group = vim.api.nvim_create_augroup("cmdzero", {})

    vim.api.nvim_create_autocmd("CmdlineEnter", {
        group = group,
        callback = function()
            M.detach()
            vim.cmd("redraw")
        end,
    })

    vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = group,
        callback = function()
            M.attach()
        end,
    })

    M.attach()
end

function M.handle(event, ...)
    local event_group, event_type = event:match("([a-z]+)_(.*)")
    local on = "on_" .. event_type

    log.debug("handle", event, ..., on)

    local ok, handler = pcall(require, "cmdzero.ui." .. event_group)
    if ok and type(handler[on]) == "function" then
        handler[on](event, ...)
    end
end

return M
