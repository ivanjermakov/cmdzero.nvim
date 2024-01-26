local queue = require("cmdzero.queue")

local M = {}

M.on_clear = function()
    queue.queue({ event = "msg_clear" })
end

M.on_showmode = function(event, content)
    if vim.tbl_isempty(content) then
        queue.queue({ event = event, clear = true })
    else
        queue.queue({ event = event, chunks = content, clear = false })
    end
end

M.on_showcmd = function(event, content)
    M.on_showmode(event, content)
end

M.on_show = function(event, kind, content, replace_last)
    if kind == "return_prompt" then
        return vim.api.nvim_input("<cr>")
    end
    if kind == "confirm" then
        M.return_control()
        return
    end
    queue.queue({ event = event, kind = kind, chunks = content, clear = replace_last })
end

M.on_confirm = M.return_control

M.return_control = function()
    -- detach and reattach on the next schedule, so the user can do the confirmation
    local ui = require("cmdzero.ui")
    ui.detach()
    vim.schedule(function()
        ui.attach()
    end)
end

M.on_history_show = function(event, entries)
    -- TODO: show history in a separate buffer
end

return M
