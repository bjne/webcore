local hook = require "webcore.hook"
local plug = require "webcore.plugin"
local proc = require "webcore.process"

local log = webcore.log

local hook_init_worker = hook.create('init_worker')
local hook_priveleged_agent = hook.create('privileged_agent')

return function(phase)
    local priveleged_agent = proc.type() == "privileged agent"
    local master_pid = proc.get_master_pid()

    if not plug.init() then
        if not priveleged_agent then
            return proc.signal_graceful_exit()
        end

        return ngx.timer.at(0, function()
            if not plug.init() then
                log.CRIT("failed to load required plugins")
                ngx.sleep(5)
            end

            return proc.kill(master_pid)
        end)
    end

    if priveleged_agent then
        if ngx.config.nginx_version < 1013008 then
            return log.ERR("can not enable priveleged agent: nginx < 1.13.8")
        end

        return hook_priveleged_agent(master_pid)
    end

    return hook_init_worker()
end

-- vim: ts=4 sw=4 et ai
