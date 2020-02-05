local insert = table.insert
local ipairs = ipairs
local pairs = pairs
local type = type

return function(t)
    local dependencies, done, sorted, circular_dependency = {}, {}, {}

    local function add_dependencies(a, b, a_t)
        local t, x = a_t and a or b, a_t and b or a

        for _,y in ipairs(type(t) == "table" and t or {t}) do
            dependencies[a_t and y or x] = dependencies[a_t and y or x] or {}
            dependencies[a_t and x or y] = dependencies[a_t and x or y] or {}
            insert(dependencies[a_t and x or y], a_t and y or x)
        end
    end


    for name, m in pairs(t) do
        if m.before then
            add_dependencies(name, m.before, false)
        end

        if m.after then
            add_dependencies(m.after, name, true)
        end

        if not m.after and not m.before then
            dependencies[name] = dependencies[name] or {}
        end
    end


    local function visit(k0)
        done[k0] = false

        for _, k1 in ipairs(dependencies[k0]) do
            if not done[k1] and (done[k1] == false or visit(k1) == false) then
                circular_dependency = circular_dependency or k0 .. ' <=> ' .. k1
                return false
            end
        end

        done[k0], sorted[#sorted + 1] = true, k0
    end


    for m1 in pairs(dependencies) do
        if not done[m1] and visit(m1) == false then
            return nil, "circular dependency: " .. circular_dependency
        end
    end


    return sorted
end

-- vim: ts=4 sw=4 et ai
