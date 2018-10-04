local _M = { _VERSION = 0.1 }

local log = ngx.log

local ERR = ngx.ERR
local CRIT = ngx.CRIT
local NOTICE = ngx.NOTICE

_M.ERR = function(...)
    log(ERR, ...)
end

_M.CRIT = function(...)
    log(CRIT, ...)
end

return _M

-- vim: ts=4 sw=4 et ai
