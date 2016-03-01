## check prepared sceleton

 * XX <- studentnumber [1..18]

### ssh into admin box

1. ssh user@10.242.XX0
1. w
1. last
1. ps aux | less
1. sudo -i
1. salt-key -L
  * salt-key -A -y
1. salt \* test.ping
1. salt \* service.status telegraf
1. salt \*suricata\* service.status suricata
1. salt \*suricata\* service.status logstash
1. salt \*elastic\* service.status elasticsearch
1. service status elasticsearch
1. service status influxdb
1. service status telegraf
1. netstat -ntple


### :9200 elasticsearch

 1. http://10.242.11.XX0:9200/
 1. http://10.242.11.XX0:9200/_cat
 1. http://10.242.11.XX0:9200/_cat/nodes?v

 ```
 $ curl -XGET http://10.242.11.XX0:9200/_cat/nodes?v
 ```


 * http://10.242.11.XX0:9200/_plugin/head

### :8083, :8086 influxdb

 1. http://10.242.11.XX0:8086/query?q=SHOW+DATABASES
 1. http://10.242.11.XX0:8086/query?q=SHOW+MEASUREMENTS&db=telegraf
 1. http://10.242.11.XX0:8086/query?q=SHOW+TAG+VALUES+FROM+%22cpu%22+WITH+KEY+%3D+%22host%22&db=telegraf


 * open in browser http://10.242.11.XX0:8083/

 1. set current database to *telegraf*

```
$ curl -XGET 'http://somehostname:8086/query?db=mydb' --data-urlencode 'q=SHOW MEASUREMENTS'
```

### :5601 Kibana4

* open in browser http://10.242.11.XX0:5601


1. Index name or pattern
1. Time-field name
1. click *Discover* tab on top left

### :3000 Grafana

* open in browser http://10.242.11.XX0:3000/

1. click *Data Sources* (http://10.242.11.XX0:3000/datasources)
1. click *Add new* (http://10.242.11.XX0:3000/datasources/new)
1. set *Name* to *telemetry*
1. set *Type* to *InfluxDB 0.9.x*
1. set *Url* to *http://10.242.11.XX0:8086*
1. set *Database* to *telegraf*
1. set *User* and *Password* to *admin*
1. click *Test Connection*
1. click *Save*
