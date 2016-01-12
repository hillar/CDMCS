# Reputation

see
* https://redmine.openinfosecfoundation.org/projects/suricata/wiki/IP_Reputation
* https://redmine.openinfosecfoundation.org/projects/suricata/wiki/IPReputationConfig
* https://redmine.openinfosecfoundation.org/projects/suricata/wiki/IPReputationFormat
* https://redmine.openinfosecfoundation.org/projects/suricata/wiki/IPReputationRules



#### Categories file

The categories file provides a mapping between a category number, short name and long description.


```
<id>,<short name>,<discription>
```

#### Reputation file
The reputation file lists a reputation score for hosts in the categories.

```
<ip>,<cat>,<score>
```

#### Rule file
```
iprep:<side to check>,<cat>,<operator>,<value>
```

#### configuration

```
#reputation-categories-file: /usr/local/etc/suricata/iprep/categories.txt
#default-reputation-path: /usr/local/etc/suricata/iprep
#reputation-files:
# - reputation.list

default-rule-path: /usr/local/etc/suricata/rules
rule-files:
 - ../iprep/iprep.rules
```

#### Reload

Only the reputation files will be reloaded, the categories file won’t be.
If categories change, Suricata should be restarted.
