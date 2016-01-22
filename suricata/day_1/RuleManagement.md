# Rule management

see https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Suricatayaml#Rule-files

https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Rule_Management_with_Oinkmaster

https://github.com/StamusNetworks/Scirius

## Config

``` yaml
default-rule-path: /etc/suricata/rules/
rule-files:
  - backdoor.rules
  - bad-traffic.rules
  - chat.rules
  - ddos.rules
  - ....
```
