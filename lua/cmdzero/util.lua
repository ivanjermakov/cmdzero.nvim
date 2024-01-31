local M = {}

---@param str string
---@param delimiter string
---@return string[]
---@source https://gist.github.com/jaredallard/ddb152179831dd23b230
M.split = function(str, delimiter)
    local t = {}
    for s in string.gmatch(str, "([^" .. delimiter .. "]+)") do
        table.insert(t, s)
    end
    return t
end

return M
