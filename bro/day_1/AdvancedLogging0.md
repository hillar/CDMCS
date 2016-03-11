# Structured logging

* https://www.bro.org/sphinx/scripts/policy/tuning/json-logs.bro.html

## Unstructured conn log

```
1449516638.400427       CreaaN3V0Fcx0Nj4xc      192.168.11.11   59518   192.168.12.12   443     tcp     http    0.040555        88      170     SF   --       0       ShADadfF        7       460     7       542     (empty)
```

## Structured conn log

```
{"ts":1449516638.400427,"uid":"CeHdP448pqXC61wZC6","id.orig_h":"192.168.11.11","id.orig_p":59518,"id.resp_h":"192.168.12.12","id.resp_p":443,"proto":"tcp","service":"http","duration":0.040555,"orig_bytes":88,"resp_bytes":170,"conn_state":"SF","missed_bytes":0,"history":"ShADadfF","orig_pkts":7,"orig_ip_bytes":460,"resp_pkts":7,"resp_ip_bytes":542,"tunnel_parents":[]}
```