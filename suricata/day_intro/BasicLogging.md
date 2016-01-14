# logging

see http://jasonish-suricata.readthedocs.org/en/latest/output/index.html

## file

### unified2 aka Barnyard2

### json
Starting in 2.0, Suricata can output alerts, http events, dns events, tls events and file info through json.

## syslog

Suricata can alert via sylog

## whatever

 * lua-output ;)

## alerts

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

----

[next: view events](/suricata/day_intro/EveView.md)
