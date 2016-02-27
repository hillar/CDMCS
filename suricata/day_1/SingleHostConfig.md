# configuration

see
 * http://jasonish-suricata.readthedocs.org/en/latest/configuration/suricata-yaml.html
 * http://jasonish-suricata.readthedocs.org/en/latest/configuration/index.html
 * https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Suricatayaml
 * http://pevma.blogspot.com.ee/2015/10/suricata-with-afpacket-memory-of-it-all.html
 * http://www.yaml.org

## Backup current configuration
```
root@secx:~# cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.bak
```

## See all currently active configuration
```
root@secx:~# grep -v -E '^\s*#' /etc/suricata/suricata.yaml | grep -v '^$'
```

Fortunately, suricata.yaml is quite well explained within the comments.



### Test changes before running your new configuration!

```
suricata -c /etc/suricata/suricata.yaml -T
#or
suricata -c /etc/suricata/suricata.yaml -T -v
```

## HOME_NET and ports
As a bare minimum, you should define your home network:
```
root@secx:~# grep 'HOME_NET' /etc/suricata/suricata.yaml
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

Where are which hosts?
```
root@secx:~# grep -A 14 'host-os-policy:' /etc/suricata/suricata.yaml
host-os-policy:
  # Make the default policy windows.
  windows: [0.0.0.0/0]
  bsd: []
  bsd-right: []
  old-linux: []
  linux: [10.0.0.0/8, 192.168.1.100, "8762:2352:6241:7245:E000:0000:0000:0000"]
  old-solaris: []
  solaris: ["::1"]
  hpux10: []
  hpux11: []
  irix: []
  macos: []
  vista: []
  windows2k3: []
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


## Optimizing the default configuration for performance

see:
 * http://jasonish-suricata.readthedocs.org/en/latest/configuration/suricata-yaml.html#max-pending-packets
 * http://jasonish-suricata.readthedocs.org/en/latest/configuration/suricata-yaml.html#detection-engine


### My test machine (yes, it is old)
 * Intel® Xeon® Processor E5630 (12M Cache, 2.53 GHz);
  * 1 Physical CPU;
  * 4 cores; (8 threads with Hyper-Threading enabled).
 * RAM: 72GB PC3-10600 (DDR3-1333) Registered CAS-9 Memory;
 * 1Gbit/s traffic
 * Almost 12,000 EmergingThreats rules enabled
<!--- * Default conf dropped packets already at 150Mbit/s, After conf optimizations it could handle 1000Mbit/s without drops -->

###Simultaneous packet processing
Default number of packets allowed to be processed simultaneously by Suricata.
```
root@secx:~# grep 'max-pending-packets:' /etc/suricata/suricata.yaml
#max-pending-packets: 1024
```

The default is rather conservative if you have a powerful CPU. For example, increasing this limit to 4,096 showed a slight improvement in performance. Overdoing it can degrade performance, since it negatively impacts caching.
```
max-pending-packets: 4096
```

### Detection engine



<!--- Eric will talk about it
###Threading
```
root@secx:~# grep 'detect-thread-ratio:' /etc/suricata/suricata.yaml
  detect-thread-ratio: 1.5

root@secx:~# grep -A 35 'set-cpu-affinity:' /etc/suricata/suricata.yaml
  set-cpu-affinity: no
  # Tune cpu affinity of suricata threads. Each family of threads can be bound
  # on specific CPUs.
  cpu-affinity:
    - management-cpu-set:
        cpu: [ 0 ]  # include only these cpus in affinity settings
    - receive-cpu-set:
        cpu: [ 0 ]  # include only these cpus in affinity settings
    - decode-cpu-set:
        cpu: [ 0, 1 ]
        mode: "balanced"
    - stream-cpu-set:
        cpu: [ "0-1" ]
    - detect-cpu-set:
        cpu: [ "all" ]
        mode: "exclusive" # run detect threads in these cpus
        # Use explicitely 3 threads and don't compute number by using
        # detect-thread-ratio variable:
        # threads: 3
        prio:
          low: [ 0 ]
          medium: [ "1-2" ]
          high: [ 3 ]
          default: "medium"
    - verdict-cpu-set:
        cpu: [ 0 ]
        prio:
          default: "high"
    - reject-cpu-set:
        cpu: [ 0 ]
        prio:
          default: "low"
    - output-cpu-set:
        cpu: [ "all" ]
        prio:
           default: "medium"
```
END OF THREADING SECTION-->


## logs

```
root@secx:~# grep log-dir /etc/suricata/suricata.yaml
default-log-dir: /var/log/suricata/
...
```

More of logging in the next chapter

----

<!--- [next : build from source](/suricata/day_1/BuildFromSource.md) -->

[skip to : Rules management](/suricata/day_1/RuleManagement.md)
