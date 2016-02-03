# Flow Probe

Suricata keeps ‘flow’ records:

* bidirectional
* uses 5 or 7 tuple depending on VLAN support
* used for storing various ‘states’
* TCP tracking and reassembly
 * HTTP parsing
* Flow records are updated per packet
* Flow records time out

Flow output records:

* IP protocol, source, destination, source port, destination port
* packet count, bytes count
* start time stamp (first packet), end time stamp (last packet)
* L7 protocol as detected based on traffic content
* TCP
 * flags seen
 * state at flow end

```yaml
# bi-directional flows
- flow
```


```json
 {
  "_index": "logstash-2016.02.03",
  "_type": "SELKS",
  "_id": "AVKox_drE4DnavQE_df3",
  "_score": null,
  "_source": {
    "timestamp": "2016-02-03T22:17:03.002103+0200",
    "flow_id": 140023364304784,
    "event_type": "flow",
    "src_ip": "10.242.3.7",
    "src_port": 7653,
    "dest_ip": "39.255.255.25",
    "dest_port": 1900,
    "proto": "UDP",
    "flow": {
      "pkts_toserver": 1,
      "pkts_toclient": 0,
      "bytes_toserver": 143,
      "bytes_toclient": 0,
      "start": "2016-02-03T22:16:32.263423+0200",
      "end": "2016-02-03T22:16:32.263423+0200",
      "age": 0,
      "state": "new",
      "reason": "timeout"
    },
    "@version": "1",
    "@timestamp": "2016-02-03T20:17:03.002Z",
    "host": "rtws-yellow-1-medium-1",
    "path": "/var/log/suricata/eve.json",
    "type": "SELKS"
  }
```

```yaml
# uni-directional flows
- netflow
```

```json
{
  "_index": "logstash-2016.02.03",
  "_type": "SELKS",
  "_id": "AVKozJ01E4DnavQE_jPq",
  "_score": null,
  "_source": {
    "timestamp": "2016-02-03T22:22:07.002256+0200",
    "flow_id": 140023364362240,
    "event_type": "netflow",
    "src_ip": "10.22.0.10",
    "src_port": 35034,
    "dest_ip": "18.62.222.25",
    "dest_port": 24497,
    "proto": "TCP",
    "netflow": {
      "pkts": 34,
      "bytes": 33300,
      "start": "2016-02-03T22:17:45.364052+0200",
      "end": "2016-02-03T22:21:06.760810+0200",
      "age": 201
    },
    "tcp": {
      "tcp_flags": "00"
    },
    "@version": "1",
    "@timestamp": "2016-02-03T20:22:07.002Z",
    "host": "rtws-yellow-1-medium-1",
    "path": "/var/log/suricata/eve.json",
    "type": "SELKS",
    "geoip": {
      "ip": "178.62.222.205",
      "country_code2": "RU",
      "country_code3": "RUS",
      "country_name": "Russian Federation",
      "continent_code": "EU",
      "latitude": 60,
      "longitude": 100,
      "location": [
        100,
        60
      ],
      "coordinates": [
        100,
        60
      ]
    }
  }
```
