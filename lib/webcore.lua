webcore = { log = require("webcore.log") }

require "resty.core"
require "webcore.package"

local conf = require "webcore.nginx.conf"
local hook = require "webcore.hook"

local get_phase, handler = ngx.get_phase, {}

for phase in pairs(conf.get_phases()) do
    handler[phase] = require.safe('webcore.phase.' .. phase)
        or hook.create(phase)
end

return setmetatable(webcore, { __call = function(self, ...)
    return handler[get_phase()](...)
end})

-- vim: ts=4 sw=4 et ai
