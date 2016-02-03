# DNS Probe

Suricata does stateful DNS tracking for UDP and TCP

```json
{
  "_index": "logstash-2016.02.03",
  "_type": "SELKS",
  "_id": "AVKo0dtdE4DnavQE_p1P",
  "_score": null,
  "_source": {
    "timestamp": "2016-02-03T22:27:51.201423+0200",
    "flow_id": 140371952721904,
    "in_iface": "eth2",
    "event_type": "dns",
    "src_ip": "10.22.3.20",
    "src_port": 50398,
    "dest_ip": "10.42.2.2",
    "dest_port": 53,
    "proto": "UDP",
    "dns": {
      "type": "query",
      "id": 24746,
      "rrname": "traffic2.ex",
      "rrtype": "A",
      "tx_id": 0
    },
    "@version": "1",
    "@timestamp": "2016-02-03T20:27:51.201Z",
    "host": "rtws-yellow-1-medium-2",
    "path": "/var/log/suricata/eve.json",
    "type": "SELKS"
  }
}
```

#### elastic template

```json
"dns": {
    "properties": {
        "id": {
            "type": "long"
        },
        "rrname": {
            "norms": {
                "enabled": false
            },
            "fielddata": {
                "format": "disabled"
            },
            "type": "string",
            "fields": {
                "raw": {
                    "index": "not_analyzed",
                    "ignore_above": 256,
                    "type": "string"
                }
            }
        },
        "rrtype": {
            "norms": {
                "enabled": false
            },
            "fielddata": {
                "format": "disabled"
            },
            "type": "string",
            "fields": {
                "raw": {
                    "index": "not_analyzed",
                    "ignore_above": 256,
                    "type": "string"
                }
            }
        },
        "tx_id": {
            "type": "long"
        },
        "rcode": {
            "norms": {
                "enabled": false
            },
            "fielddata": {
                "format": "disabled"
            },
            "type": "string",
            "fields": {
                "raw": {
                    "index": "not_analyzed",
                    "ignore_above": 256,
                    "type": "string"
                }
            }
        },
        "type": {
            "norms": {
                "enabled": false
            },
            "fielddata": {
                "format": "disabled"
            },
            "type": "string",
            "fields": {
                "raw": {
                    "index": "not_analyzed",
                    "ignore_above": 256,
                    "type": "string"
                }
            }
        },
        "ttl": {
            "type": "long"
        },
        "rdata": {
            "norms": {
                "enabled": false
            },
            "fielddata": {
                "format": "disabled"
            },
            "type": "string",
            "fields": {
                "raw": {
                    "index": "not_analyzed",
                    "ignore_above": 256,
                    "type": "string"
                }
            }
        }
    }
}
```
