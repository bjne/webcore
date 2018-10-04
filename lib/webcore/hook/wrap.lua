local empty_table, tail_wrapper = {}, function() return true end

local log = webcore.log

return function(hook, sorted_plugins, hook_plugins)
    local run, hook_name = tail_wrapper, hook.name

    local _run = function(hook, modules, ...)
        return run(...)
    end

    for i=#(sorted_plugins or empty_table),1,-1 do
        local name = sorted_plugins[i]
        local plug = hook_plugins[name]

        if not plug then
            log.CRIT("missing module hook: " .. hook_name .. "/" .. name)
        elseif not plug.action then
            log.CRIT("missing module action: " .. name)
        else
            local action = plug.action
            local next_wrapper, wrapper = run

            if plug.need_config then
                wrapper = function(config, ...)
                    -- print("RUNNING:", hook_name, name)
                    if config[name] then
                        local ok, done = action(config[name], ...)
                        if not ok or done then
                            return ok, done
                        end
                    else
                        log.CRIT("NO CONFIG FOR:", hook_name, name)
                    end

                    return next_wrapper(config, ...)
                end
            else
                wrapper = function(config, ...)
                    local ok, done = action(...)
                    if not ok or done then
                        return ok, done
                    end

                    return next_wrapper(config, ...)
                end
            end

            run = wrapper
        end
    end


    return run == tail_wrapper and run or _run
end

-- vim: ts=4 sw=4 et ai
