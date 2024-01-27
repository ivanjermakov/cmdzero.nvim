local render = require("cmdzero.render")
local log = require("cmdzero.log")

---@class Message
---@field event string
---@field kind? string
---@field chunks? table
---@field clear? boolean 

local M = {}

function M.setup()
    vim.schedule(M.run)
end

M._queue = {}

function M.run()
    while #M._queue > 0 do
        local message = table.remove(M._queue, 1)

        if message.event == "msg_clear" then
            render.clear()
        end

        -- for some reason, msg_showmode is often send without content and it clears active message unsolicitedly
        if message.event == "msg_show" or message.event == "msg_showmode" then
            render.render(message)
        end
    end
    vim.defer_fn(M.run, 100)
end

---@param message Message
function M.queue(message)
    log.debug("queue", message)
    table.insert(M._queue, message)
end

return M
