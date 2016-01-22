# LUA output

see https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Lua_Output

see (old) https://gist.github.com/hillar/aeae0b6d12de4ccd8ced#file-suricata_flow2ela-lua

## build with LuaJit



## enable in config

``` yaml
outputs:
  - lua:
      enabled: yes
      scripts-dir: /etc/suricata/lua-output/
      scripts:
        - tcp-data.lua
        - flow.lua

```
## needs["type", "protocol"]

## outputs to ..

  * file
  * http
  * ...
