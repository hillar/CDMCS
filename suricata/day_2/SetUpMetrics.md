# set up metrics

 * ethx ?
 * cpu ?
 * ram ?
 * disk ?
 * ...

good old munin, syweb, nagios, ....

however, we use: 

* [telegraf](./boxes/scripts/install-telegraf.sh) to collect metrix
* [influxdb](./boxes/scripts/install-influxdb.sh) to hold metrix 
* [grafana](./boxes/scripts/install-grafana.sh) to show metrix

see 
* http://oss.oetiker.ch/rrdtool/
* https://github.com/influxdata/telegraf
* https://github.com/influxdata/influxdb
* https://influxdata.com/wp-content/themes/influx/images/TICK-Stack.png
* https://github.com/grafana/grafana 
* http://play.grafana.org


----

[next : elastic](/suricata/day_2/SetUpElastic.md)
