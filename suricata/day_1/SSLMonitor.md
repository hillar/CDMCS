# SSL Monitor

see

* https://www.stamus-networks.com/2015/07/24/finding-self-signed-tls-certificates-suricata-and-luajit-scripting/
* https://resources.sei.cmu.edu/asset_files/Presentation/2016_017_001_449890.pdf


#### eve
```json
{
  "_index": "logstash-2016.02.03",
  "_type": "SELKS",
  "_id": "AVKnLZNJBzrbu4sSBuRs",
  "_score": 1,
  "_source": {
    "timestamp": "2016-02-03T14:48:46.484856+0200",
    "event_type": "engine",
    "engine": {
      "message": "enabling 'eve-log' module 'tls'"
    },
    "@version": "1",
    "@timestamp": "2016-02-03T12:48:46.484Z",
    "host": "rtws-yellow-1-medium-1",
    "path": "/var/log/suricata/suricata.json",
    "type": "SELKS"
  }
}
```

#### TLS Logging Example

```json

{
  "_index": "logstash-2016.02.03",
  "_type": "SELKS",
  "_id": "AVKo7VVns9d5M18pys8A",
  "_score": null,
  "_source": {
    "timestamp": "2016-02-03T22:57:50.899152+0200",
    "flow_id": 139854564246144,
    "in_iface": "eth1",
    "event_type": "tls",
    "src_ip": "10.242.11.11",
    "src_port": 52226,
    "dest_ip": "103.234.36.144",
    "dest_port": 443,
    "proto": "TCP",
    "tls": {
      "subject": "CN=www.kzjcxnoy2jwvznhlr.net",
      "issuerdn": "CN=www.aczcjywnbjiuoy.com",
      "fingerprint": "a8:e5:5d:6c:d6:0a:2b:09:d9:9b:b2:6f:51:0c:7a:4c:11:55:93:b4",
      "version": "TLS 1.2"
    },
    "@version": "1",
    "@timestamp": "2016-02-03T20:57:50.899Z",
    "host": "rtws-yellow-1-medium-3",
    "path": "/var/log/suricata/eve.json",
    "type": "SELKS"
  }
}
```
