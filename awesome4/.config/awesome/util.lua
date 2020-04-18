local M = {}
M.to169 = function(c)
    if (c.width > 16 * c.height / 9) then
        c.width = 16 * c.height / 9
    else
        c.height = 9 * c.width / 16
    end
end

return M