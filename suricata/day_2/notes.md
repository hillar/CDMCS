## check prepared sceleton

 * XX <- studentnumber [1..18]

### ssh into admin box

1. ssh user@10.242.11.XX0
1. w
1. last
1. cat /etc/salt/minion
 ```
master: 10.242.11.9
id: student-XX-admin
 ```

1. ps aux | less
1. sudo -i
1. salt-key -L
 ```
Accepted Keys:
Denied Keys:
Unaccepted Keys:
student-18-elasticsearch-1
student-18-elasticsearch-2
student-18-elasticsearch-3
student-18-suricata-1
student-18-suricata-2
student-18-suricata-4
student-18-suricata-5
 ```
  * salt-key -A -y
1. salt '\*' test.ping
1. salt '\*' service.status telegraf
1. salt '\*suricata\*' service.status suricata
1. salt '\*suricata\*' service.status logstash
1. salt '\*elastic\*' service.status elasticsearch
1. service elasticsearch status
1. service influxdb status
1. service telegraf status
1. netstat -ntple
```

### :9200 elasticsearch

1. http://10.242.11.XX0:9200/
1. http://10.242.11.XX0:9200/_cat
1. http://10.242.11.XX0:9200/_cat/nodes?v

 ```
 $ curl -XGET http://10.242.11.XX0:9200/_cat/nodes?v
 ```


* open in browser http://10.242.11.XX0:9200/_plugin/head


1. click *Indices*
1. click *Browser*
1. click *Overview*


### :5636 EveBox

* open in browser http://10.242.11.XX0:5636/


1. click *settings*
1. set *Elastic Search URL* to *http://10.242.11.XX0:9200*  
1. click *save*
1. click *Events*
1. click *any row*
1. click *back*  

### :8083, :8086 influxdb

 1. http://10.242.11.XX0:8086/query?q=SHOW+DATABASES
 1. http://10.242.11.XX0:8086/query?q=SHOW+MEASUREMENTS&db=telegraf
 1. http://10.242.11.XX0:8086/query?q=SHOW+TAG+VALUES+FROM+%22cpu%22+WITH+KEY+%3D+%22host%22&db=telegraf

 ```
 $ curl -XGET 'http://somehostname:8086/query?db=mydb' --data-urlencode 'q=SHOW MEASUREMENTS'
 ```

 * open in browser http://10.242.11.XX0:8083/


 1. set current database to *telegraf*
 1. click *Query Templates*
 1. select *SHOW DATABASES*
 1. loop around ...



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


1. click *Dashboards*
1. click *Home*
1. click *New*
1. click *small green box on top left*
1. choose *add panel* - *graph*
1. set *From*  to *cpu*
1. set *Where* to *cpu* = *cpu-total*
1. set *Select* to *usage_idle*
1. set *group by* to *host*
1. click *floppy image* on top
1. click *Panel Title*
1. select *edit*
1. play around ...
1. click *floppy image* on top

### :8000 Scirius

 * open in browser http://10.242.11.XX0:8000/
 * user *admin* password *admin*
 * click on *elasticsearch*
 * look around ...
