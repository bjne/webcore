local hook = require "webcore.hook"
local pack = require "webcore.package"

local _M = { _VERSION = 0.1 }

local plugins, empty_table, plugins_loaded = {}, {}

_M.init = function()
    if plugins_loaded then
        return true
    end

    local list = require.safe(pack.name('plugins'))

    for _, plugin_name in ipairs(list or empty_table) do
        local plugin = require.safe(plugin_name)
        if plugin then
            plugins_loaded = plugins_loaded ~= false and true or false
            plugins[plugin_name] = plugin
        else
            plugins_loaded = false
        end
    end

    if not plugins_loaded and #plugins > 0 then
        hook.init(plugins, 'require_bytecode')
    else
        plugins_loaded = hook.init(plugins)
    end

    return plugins_loaded
end

return _M

-- vim: ts=4 sw=4 et ai
