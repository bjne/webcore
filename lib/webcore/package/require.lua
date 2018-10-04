getfenv(0).require = require "resty.require"

local hook = require "webcore.hook"

local code_cache = ngx.shared.code_cache
local get_phase = ngx.get_phase
local insert = table.insert
local match = string.match
local load = load

local hook_require_bytecode = hook.create('require_bytecode')

code_cache:add("/updated", ngx.now() * 1E9)

local function require_bytecode(package)
    local code = code_cache:get(package) or hook_require_bytecode(package)

    if code then
        local _code = load(code, nil, 'b')
        code = _code, _code and code_cache:set(package, code)
    end

    return code
end

return insert(require.loaders, 2, require_bytecode)

-- vim: ts=4 sw=4 et ai
