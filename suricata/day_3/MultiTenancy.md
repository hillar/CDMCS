# Multi Tenancy

Multi tenancy support allows for different rule sets with different rule vars.



see  http://jasonish-suricata.readthedocs.org/en/latest/configuration/multi-tenant.html

and also
 * https://github.com/inliniac/suricata/blob/37a64bdd45936875598925f7ccde420e4efdc450/src/unix-manager.c#L880
 * https://github.com/inliniac/suricata/blob/37a64bdd45936875598925f7ccde420e4efdc450/src/runmode-unix-socket.c#L440




## configuration

```
multi-detect:
  enabled: yes
  #selector: direct # direct or vlan
  selector: vlan
  loaders: 3

  tenants:
  - id: 1
    yaml: tenant-1.yaml
  - id: 2
    yaml: tenant-2.yaml
  - id: 3
    yaml: tenant-3.yaml

  mappings:
  - vlan-id: 1000
    tenant-id: 1
  - vlan-id: 2000
    tenant-id: 2
  - vlan-id: 1112
    tenant-id: 3


```

## Unix Socket

```
register-tenant-handler 1 vlan 1000

unregister-tenant-handler 4 vlan 1111

```
