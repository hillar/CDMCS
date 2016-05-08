# lua

see
* https://github.com/aol/moloch/commit/7f03eeffced17ee56f902659df77ac40d6675d6b
* https://github.com/aol/moloch/blob/master/capture/plugins/lua/README.md



```lua
-- To use add
--   plugins=lua.so
--   lauFiles=/path/moloch.lua
-- This script is run per packetThread, so any globals will be shared
-- for all packets processed by this thread.  

-- session - userdata session object
-- data - the binary data
-- direction - socket direction
-- return - -1 means stop parsing
function foo_parser(session, data, direction)
    print("\nparser:\n", "\nsession:", session, "\nwhich:", which, "\n")
    moloch_field_add_string(session, "protocols", "newprotocol"..cnt)
    return -1;
end

-- session - userdata session object
-- data - the binary data
-- direction - socket direction
function foo_classify(session, data, direction)
    print ("classify", session, which, data)
    moloch_session_add_tag(session, "foofoobarbar"..cnt)
    moloch_field_add_string(session, "user", "luauser"..cnt)
    moloch_field_add_int(session, portSocksField, 12345 + cnt)
    moloch_parsers_register(session, foo_parser)
    cnt = cnt+1
end

-- name, offset to check for match in data, binary match data, "function name"
moloch_parsers_classifier_register_tcp("all", 0, "", "foo_classify")
moloch_parsers_classifier_register_udp("all", 0, "", "foo_classify")

-- convert expression to fieldId
portSocksField = moloch_field_by_exp("port.socks");

-- Just to make things added unique and make sure things are working. :)
cnt = 0; -- remember global per thread
```
