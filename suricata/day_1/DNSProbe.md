# DNS Probe

Suricata does stateful DNS tracking for UDP and TCP

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
