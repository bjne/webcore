webcore = { log = require("webcore.base.log") }

require "resty.core"
require "webcore.base.package"

local conf = require "webcore.base.nginx.conf"
local hook = require "webcore.base.hook"

local get_phase, handler = ngx.get_phase, {}

for phase in pairs(conf.get_phases()) do
    handler[phase] = require.safe('webcore.base.phase.' .. phase)
        or hook.create(phase)
end

return setmetatable(webcore, { __call = function(self, ...)
    return handler[get_phase()](...)
end})

-- vim: ts=4 sw=4 et ai
