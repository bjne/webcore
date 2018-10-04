``` nginx.conf
init_by_lua_block {
    require ("webcore"){name = "core", prefix = "bjne"}
}

http {
    location / {
        access_by_lua_block {
            webcore()
        }

        content_by_lua_block {
            webcore()
        }
    }
}
```

requires
========
https://github.com/bjne/lua-resty-require

usage
=====

place a list of the plugins you want to hook in in:
```
package.path/{{ prefix }}/plugins/{{ name }}.lua
```

example
=======

bjne/plugins/core.lua
``` lua
return {
    "bjne.foo",
    "bjne.bar"
}
```

bjne/bar.lua
``` lua
return {
    access = {
        action = function() return true end
    },
    content = {
        action = function() return true, nil, ngx.say("bar") end,
        after = "bjne.foo"
    }
}
```

bjne/foo.lua
``` lua
return {
    content = {
        action = function() return true, nil, ngx.say("foo") end
    }
}
```

[comment]: <> # vim: ts=4 et
