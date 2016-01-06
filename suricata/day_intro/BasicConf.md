# configuration

see
 * http://jasonish-suricata.readthedocs.org/en/latest/configuration/suricata-yaml.html
 * https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Suricatayaml

## Yaml

Suricata uses the Yaml format for configuration.

see http://www.yaml.org

### set configuration file location

```
suricata -c /bla/blah/suricata.yaml
```

### test configuration file

```
suricata -c /bla/blah/suricata.yaml -T
```
> missing threshold.config
> see http://permalink.gmane.org/gmane.comp.security.ids.oisf.user/1738

```
root@secx:~# touch /etc/suricata/threshold.config
root@secx:~# /usr/bin/suricata -T -c /etc/suricata/suricata.yaml
6/1/2016 -- 14:25:47 - <Info> - Running suricata under test mode
6/1/2016 -- 14:25:47 - <Notice> - This is Suricata version 2.0.11 RELEASE
```

## HOME_NET

At least, you will need to define your home network:
```
HOME_NET: "[192.168.100.0/24]"
EXTERNAL_NET: !$HOME_NET
```
```
root@secx:~# grep HOME_NET /etc/suricata/suricata.yaml
    HOME_NET: "[192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]"
    EXTERNAL_NET: "!$HOME_NET"
    HTTP_SERVERS: "$HOME_NET"
    SMTP_SERVERS: "$HOME_NET"
    SQL_SERVERS: "$HOME_NET"
    DNS_SERVERS: "$HOME_NET"
    TELNET_SERVERS: "$HOME_NET"
    DNP3_SERVER: "$HOME_NET"
    DNP3_CLIENT: "$HOME_NET"
    MODBUS_CLIENT: "$HOME_NET"
    MODBUS_SERVER: "$HOME_NET"
    ENIP_CLIENT: "$HOME_NET"
    ENIP_SERVER: "$HOME_NET"
```

## Rules

```
root@secx:~# grep rule-path /etc/suricata/suricata.yaml
default-rule-path: /etc/suricata/rules
```

### do you need rules !?

```
root@secx:~# suricata -T -c /etc/suricata/suricata.yaml --disable-detection
6/1/2016 -- 14:47:28 - <Info> - Running suricata under test mode
6/1/2016 -- 14:47:28 - <Info> - detection engine disabled
6/1/2016 -- 14:47:28 - <Notice> - This is Suricata version 2.0.11 RELEASE
```


## logs

```
root@secx:~# grep log-dir /etc/suricata/suricata.yaml
default-log-dir: /var/log/suricata/
...
```

----

[next : basic logging](/suricata/day_intro/BasicLogging.md)
