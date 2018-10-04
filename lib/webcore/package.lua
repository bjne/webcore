require "webcore.package.require"

local concat = table.concat

local _M = { _VERSION = 0.1 }

local package_name, package_idx, initialized = {}, 1

local init = function()
    if not webcore.config or initialized then
        return
    end

    if webcore.config.prefix then
        package_name[1] = webcore.config.prefix
        package_idx = 2
    end

    if webcore.config.name then
        package_name[package_idx + 1] = webcore.config.name
    end

    initialized = true
end

_M.name = function(name)
    init()

    package_name[package_idx] = name or '_undefined_'
    return concat(package_name, '.')
end

return _M

-- vim: ts=4 sw=4 et ai
