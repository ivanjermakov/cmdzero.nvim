local render = require("cmdzero.render")
local log = require("cmdzero.log")

local M = {}
local notifyRenderer = render.new("notify", {})

---@type table<string, Renderer>
M.handlers = {
    msg_show = notifyRenderer,
    msg_showmode = notifyRenderer,
}

function M.setup()
    vim.schedule(M.run)
end

M._queue = {}

function M.run()
    while #M._queue > 0 do
        local message = table.remove(M._queue, 1)

        if message.event == "msg_clear" then
            M.msg_clear()
        end

        local handler = M.handlers[message.event]
        if handler ~= nil then
            if message.clear then
                handler:clear()
            end
            if message.chunks then
                handler:add(message.chunks)
            end
        else
            log.warn("no handler for message", message)
        end
    end
    for _, r in pairs(M.handlers) do
        r:render()
    end
    vim.defer_fn(M.run, 1000)
end

---@param message { event: string, kind?: string, chunks: table}
function M.queue(message)
    log.info("queue", message)
    table.insert(M._queue, message)
end

function M.msg_clear()
    for k, r in pairs(M.handlers) do
        if k:find("msg_show") == 1 then
            r:clear()
        end
    end
end

return M
