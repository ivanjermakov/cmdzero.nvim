local render = require("cmdzero.render")
local log = require("cmdzero.log")

local M = {}

function M.setup()
    vim.schedule(M.run)
end

M._queue = {}

function M.run()
    while #M._queue > 0 do
        local message = table.remove(M._queue, 1)

        if message.clear or message.event == "msg_clear" then
            render.clear()
        end

        if message.event == "msg_show" or message.event == "msg_showmode" then
            if message.chunks then
                render.render(message)
            end
        end
    end
    vim.defer_fn(M.run, 100)
end

---@param message { event: string, kind?: string, chunks: table}
function M.queue(message)
    log.debug("queue", message)
    table.insert(M._queue, message)
end

return M
