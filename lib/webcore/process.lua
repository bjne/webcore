local process = require "ngx.process"
local ffi = require "ffi"
local C = ffi.C

ffi.cdef("int kill(int pid, int sig);")

local SIGHUP = 1

local _M = { _VERSION = 0.1 }

_M.kill = function(pid, signal)
    return C.kill(pid, signal or SIGHUP)
end

return setmetatable(_M, { __index = process })

-- vim: ts=4 sw=4 et ai
