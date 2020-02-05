local hook = require "webcore.base.hook"
local plug = require "webcore.base.plugin"
local proc = require "webcore.base.process"

local log = webcore.log

local init_hook = hook.create("init")

return function(config)
    local ok, err = proc.enable_privileged_agent()

    if not ok then
        assert(log.ERR("enables privileged agent failed error:", err))
    end

    webcore.config = config or {}

    plug.init()

    collectgarbage()

    return init_hook()
end

-- vim: ts=4 sw=4 et ai
