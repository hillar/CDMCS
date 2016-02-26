# logging

 * http://jasonish-suricata.readthedocs.org/en/latest/output/index.html
 * [Files in log directory](/suricata/day_intro/log.md)

## file

Line-based logs are easily human readable but contain limited information. Furthermore, machine processing can be expensive in terms of CPU and IO.

```
grep '\- fast' -A4 -B1 /etc/suricata/suricata.yaml
tail /var/log/suricata/fast.log
```

```
12/07/2015-19:30:03.307554  [**] [1:2200074:1] SURICATA TCPv4 invalid checksum [**] [Classification: (null)] [Priority: 3] {TCP} 192.168.11.11:42336 -> 192.168.12.12:80
```

### unified2 aka Barnyard2

Binary format for disk efficiency. Thus, IDS spends minimal resources for storing data. Further processing is offloaded to other tools.

 * https://github.com/firnsy/barnyard2
 * https://github.com/jasonish/py-idstools
 * https://github.com/threatstack/unified2
 * http://threatstack.github.io/pigsty/

### EVE (Extensible Event Format)

Starting in 2.0, Suricata can output alerts, connections and internal statistics through JSON.

 * http://www.json.org/
 * https://redmine.openinfosecfoundation.org/projects/suricata/wiki/EveJSONFormat

```
{
  "timestamp": "2015-12-07T19:29:55.093707+0000",
  "flow_id": 1.4000333881421e+14,
  "event_type": "http",
  "src_ip": "192.168.11.11",
  "src_port": 42334,
  "dest_ip": "192.168.12.12",
  "dest_port": 80,
  "proto": "TCP",
  "tx_id": 0,
  "http": {
    "hostname": "192.168.12.12",
    "url": "\/index.html?crap=1449516595",
    "http_content_type": "text\/html",
    "http_method": "GET",
    "protocol": "HTTP\/1.1",
    "status": 200,
    "length": 1
  }
}
```

```
grep 'eve-log' -A10 /etc/suricata/suricata.yaml
```

Following event types can be enabled in Suricata 3. 

 * Alert
 * HTTP
 * DNS
 * TLS
 * Files
 * drop
 * SMTP
 * SSH
 * Stats
 * Flow
 * Netflow

```
cat /var/log/suricata/eve.json | jq -c 'select(.event_type=="alert")'
```

## syslog

Suricata can alert via syslog.

 * https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Syslog_Alerting_Compatibility
 * https://www.ietf.org/rfc/rfc3164.txt
 * https://tools.ietf.org/html/rfc5424
 * http://www.rsyslog.com/doc/master/index.html
 * https://www.balabit.com/sites/default/files/documents/syslog-ng-ose-latest-guides/en/syslog-ng-ose-guide-admin/html-single/index.html
 * http://nxlog-ce.sourceforge.net/nxlog-docs/en/nxlog-reference-manual.html

## stuff

```
root@secx:/usr/local/var/log/suricata# cat eve.json | perl -ne 'print "$1\n" if /\"event_type\":\"(.*?)\"/' | sort | uniq -c
   1060 alert
  29841 dns
  12351 fileinfo
  12438 http
   8219 ssh
  44329 stats
```

Or with jq:

```
cat eve.json | jq -c '.event_type' | sort | uniq -c
```

----

[next: view events](/suricata/day_intro/EveView.md)
