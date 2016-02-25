# configuration

see
 * http://jasonish-suricata.readthedocs.org/en/latest/configuration/suricata-yaml.html
 * https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Suricatayaml

## Yaml

Suricata uses the Yaml format for configuration.

see http://www.yaml.org

### specify configuration file location

```
suricata -c /some/directory/suricata.yaml
```

### test configuration file

```
suricata -c /etc/suricata/suricata.yaml -T
#or
suricata -c /etc/suricata/suricata.yaml -T -v
```
> notice the missing threshold.config
> see http://permalink.gmane.org/gmane.comp.security.ids.oisf.user/1738

```
root@secx:~# touch /etc/suricata/threshold.config
root@secx:~# /usr/bin/suricata -c /etc/suricata/suricata.yaml -T
6/1/2016 -- 14:25:47 - <Info> - Running suricata under test mode
6/1/2016 -- 14:25:47 - <Notice> - This is Suricata version 2.0.11 RELEASE
```

## HOME_NET

As a bare minimum, you should define your home network:
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

Review default ports according to your environments:
```
root@secx:~# grep '_PORTS' /etc/suricata/suricata.yaml 
    HTTP_PORTS: "80"
    SHELLCODE_PORTS: "!80"
    ORACLE_PORTS: 1521
    SSH_PORTS: 22
    DNP3_PORTS: 20000
    MODBUS_PORTS: 502
```

## Rules

```
root@secx:~# grep -A51 rule-path /etc/suricata/suricata.yaml
default-rule-path: /etc/suricata/rules
rule-files:
 - botcc.rules
 - ciarmy.rules
 - compromised.rules
 - drop.rules
 - dshield.rules
 - emerging-activex.rules
 - emerging-attack_response.rules
 - emerging-chat.rules
 - emerging-current_events.rules
 - emerging-dns.rules
 - emerging-dos.rules
 - emerging-exploit.rules
 - emerging-ftp.rules
 - emerging-games.rules
 - emerging-icmp_info.rules
# - emerging-icmp.rules
 - emerging-imap.rules
 - emerging-inappropriate.rules
 - emerging-malware.rules
 - emerging-misc.rules
 - emerging-mobile_malware.rules
 - emerging-netbios.rules
 - emerging-p2p.rules
 - emerging-policy.rules
 - emerging-pop3.rules
 - emerging-rpc.rules
 - emerging-scada.rules
 - emerging-scan.rules
 - emerging-shellcode.rules
 - emerging-smtp.rules
 - emerging-snmp.rules
 - emerging-sql.rules
 - emerging-telnet.rules
 - emerging-tftp.rules
 - emerging-trojan.rules
 - emerging-user_agents.rules
 - emerging-voip.rules
 - emerging-web_client.rules
 - emerging-web_server.rules
 - emerging-web_specific_apps.rules
 - emerging-worm.rules
 - tor.rules
 - decoder-events.rules # available in suricata sources under rules dir
 - stream-events.rules  # available in suricata sources under rules dir
 - http-events.rules    # available in suricata sources under rules dir
 - smtp-events.rules    # available in suricata sources under rules dir
 - dns-events.rules     # available in suricata sources under rules dir
 - tls-events.rules     # available in suricata sources under rules dir
# - modbus-events.rules  # available in suricata sources under rules dir
 - app-layer-events.rules  # available in suricata sources under rules dir
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

More of logging in the next chapter

----

[next : basic logging](/suricata/day_intro/BasicLogging.md)
