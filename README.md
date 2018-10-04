``` nginx.conf
init_by_lua_block {
	require ("webcore"){name = "core", prefix = "bjne"}
}

other_phases_by_lua_block {
	webcore()
}
```
