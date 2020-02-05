local _M = { _VERSION = 0.1 }

local sort = require "webcore.base.hook.sort"
local wrap = require "webcore.base.hook.wrap"
local new_tab = require "table.new"

local hooks, empty_table = new_tab(0,100), new_tab(0,0)

local noop = function() end

local hook_mt = {
    __call = function(hook, ...)
        return hook.run and hook.run(...) or noop()
    end
}

local init_hook = function(plugins, hook)
    local hook_plugins, hook_name = {}, hook.name
    for plugin_name, plugin in pairs(plugins or empty_table) do
        hook_plugins[plugin_name] = plugin[hook_name]
    end

    local sorted_plugins, err = sort(hook_plugins)
    if not sorted_plugins then
        log.CRIT("failed to sort hooks: ", err)
        return nil, err
    end

    hook.run = wrap(hook, sorted_plugins, hook_plugins)

    return true
end

_M.init = function(plugins, hook_name)
    if not hook_name then
        for hook_name, hook in pairs(hooks or empty_table) do
            local ok, err = init_hook(plugins, hook)
            if not ok then
                return nil, err
            end
        end
    elseif hooks[hook_name] then
        return init_hook(plugins, hooks[hook_name])
    else
        return nil, "invalid hook"
    end

    return true
end

_M.create = function(hook_name, prefix)
    if hooks[hook_name] then
        return nil, "hook already exist, create it in plugin body"
    end

    hooks[hook_name] = new_tab(0, 6)

    hooks[hook_name].name = hook_name
    hooks[hook_name].prefix = prefix
    hooks[hook_name].plugins = new_tab(20, 1)

    return setmetatable(hooks[hook_name], hook_mt)
end

return _M

-- vim: ts=4 sw=4 et ai
