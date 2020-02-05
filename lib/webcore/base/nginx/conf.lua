local _M = { _VERSION = 0.1 }

local open = io.open
local match = string.match
local gmatch = string.gmatch

_M.get_phases = function()
    local conf = assert(open(ngx.config.prefix() .. '/conf/nginx.conf', 'r'))

    conf = conf:read('*all'), conf:close()

    local phases = { [ngx.get_phase()] = true }

    for phase, code in gmatch(conf, '\n%s*([a-z_]+)_by_lua_block%s*(%b{})') do
        if match(code, 'webcore%b()') then
            phase = phase == "ssl_certificate" and "ssl_cert" or phase
            phases[phase] = true
        end
    end

    return phases
end

return _M

-- vim: sw=4 ts=4 et ai
