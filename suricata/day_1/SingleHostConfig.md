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



## Test changes before running your new configuration!

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


### Why does it matter?
EXTERNAL_NET -> HOME_NET
HOME_NET -> EXTERNAL_NET
any -> any
...


### Review default ports according to your environments:
```
root@secx:~# grep '_PORTS' /etc/suricata/suricata.yaml 
    HTTP_PORTS: "80"
    SHELLCODE_PORTS: "!80"
    ORACLE_PORTS: 1521
    SSH_PORTS: 22
    DNP3_PORTS: 20000
    MODBUS_PORTS: 502
```


### Where are which hosts?
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


## MTU
```
root@secx:~# grep 'default-packet-size:' /etc/suricata/suricata.yaml
#default-packet-size: 1514
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




### Rule priority
Different rule types are matched in a specific priority order

```
root@secx:~# grep -A 4 'action-order' /etc/suricata/suricata.yaml
# action-order:
#   - pass
#   - drop
#   - reject
#   - alert
```



## Optimizing the default configuration for performance

see:
 * http://jasonish-suricata.readthedocs.org/en/latest/configuration/suricata-yaml.html#max-pending-packets
 * http://jasonish-suricata.readthedocs.org/en/latest/configuration/suricata-yaml.html#detection-engine
 * https://redmine.openinfosecfoundation.org/projects/suricata/wiki/High_Performance_Configuration
 * https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Tuning_Considerations
 * http://mauno.pihelgas.eu/files/Mauno_Pihelgas-A_Comparative_Analysis_of_OpenSource_Intrusion_Detection_Systems.pdf
 * https://github.com/StamusNetworks/SELKS/wiki/Tuning-SELKS



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

Inspection profile
```
root@secx:~# grep -A 12 'detect-engine:' /etc/suricata/suricata.yaml
detect-engine:
  - profile: medium
  - custom-values:
      toclient-src-groups: 2
      toclient-dst-groups: 2
      toclient-sp-groups: 2
      toclient-dp-groups: 3
      toserver-src-groups: 2
      toserver-dst-groups: 4
      toserver-sp-groups: 2
      toserver-dp-groups: 25
  - sgh-mpm-context: auto
  - inspection-recursion-limit: 3000
```
All signatures loaded into Suricata are divided in groups for faster matching.
 * high - more groups, better performance and higher memory usage;
 * medium - balance between performance and memory usage (default);
 * low - less groups, lower performance and lower memory usage.
 * custom - 8 customizable values


### Which MPM algorithm?
 * MPM - multi pattern matcher

Supported algorithms are b2g, b3g, wumanber, ac, ac-bs, and ac-gfbs

```
root@secx:~# grep '^mpm-algo:' /etc/suricata/suricata.yaml
mpm-algo: ac
```


#### Signature Group Head MPM distribution context
```
root@secx:~# grep 'sgh-mpm-context:' /etc/suricata/suricata.yaml
  - sgh-mpm-context: auto
```
 * full - every group has its own MPM-context;
 * single - all groups share one MPM-context.

If the sgh-mpm-context is set to 'auto', two algorithms ac and ac-gfbs use a single MPM-context. The rest of the algorithms use full by default. You can try different setting manually.

Some test results:
 * Using the 'ac' algorithms with 'full' distribution context required a large amount of memory. With the ET ruleset it consumed over 30GiB of memory. It did demonstrate the best results in processing speed. But is it worth it?
 * Using the 'b2gc' algorithm with 'full' context demonstrated also good performance with more reasonable memory usage (about 6GiB) in my case.



### Buffer sizes
Default receive buffer sizes for capture modules are quite safe even for portable systems.

#### af-packet mode
```
af-packet:
...
    # recv buffer size, increase value could improve performance
    # buffer-size: 32768
...
```
Instead try:
```
af-packet:
    buffer-size: 2147483647
```
---

#### PCAP mode
```
pcap:
...
    # On Linux, pcap will try to use mmaped capture and will use buffer-size
    # as total of memory used by the ring. So set this to something bigger
    # than 1% of your bandwidth.
    #buffer-size: 16777216
...
```
Instead try
```
pcap:
    buffer-size: 2147483647
```


### Memcaps
Increase memcaps and disable checksum-validation.
```
root@secx:~# grep -A6 '^stream:' /etc/suricata/suricata.yaml
stream:
  memcap: 32mb
  checksum-validation: yes      # reject wrong csums
  inline: auto                  # auto will use inline mode in IPS mode, yes or no set it statically
  reassembly:
    memcap: 128mb
    depth: 1mb                  # reassemble 1mb into a stream
```

```
root@secx:~# grep -A4 '^flow:' /etc/suricata/suricata.yaml
flow:
  memcap: 64mb
  hash-size: 65536
  prealloc: 10000
  emergency-recovery: 30
```


### Flow timeouts
```
root@secx:~# grep -A25 '^flow-timeouts' /etc/suricata/suricata.yaml
flow-timeouts:

  default:
    new: 30
    established: 300
    closed: 0
    emergency-new: 10
    emergency-established: 100
    emergency-closed: 0
  tcp:
    new: 60
    established: 3600
    closed: 120
    emergency-new: 10
    emergency-established: 300
    emergency-closed: 20
  udp:
    new: 30
    established: 300
    emergency-new: 10
    emergency-established: 100
  icmp:
    new: 30
    established: 300
    emergency-new: 10
    emergency-established: 100
```
Can we decrease something?


----

<!--- [next : build from source](/suricata/day_1/BuildFromSource.md) -->

[next : Rules management](/suricata/day_1/RuleManagement.md)













<!--- Eric will talk about it
### Threading
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

