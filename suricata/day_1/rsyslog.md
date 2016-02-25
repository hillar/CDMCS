# Rsyslog

 * http://www.rsyslog.com/ubuntu-repository/
 * http://www.rsyslog.com/tag/mmjsonparse/
 * http://www.rsyslog.com/doc/mmjsonparse.html
 * http://www.rsyslog.com/doc/v8-stable/configuration/modules/omelasticsearch.html

```
apt-cache policy rsyslog
rsyslog:
  Installed: 7.4.4-1ubuntu2.6
  Candidate: 8.16.0-0adiscon1trusty1
  Version table:
     8.16.0-0adiscon1trusty1 0
        500 http://ppa.launchpad.net/adiscon/v8-stable/ubuntu/ trusty/main amd64 Packages
 *** 7.4.4-1ubuntu2.6 0
        500 http://archive.ubuntu.com/ubuntu/ trusty-updates/main amd64 Packages
        100 /var/lib/dpkg/status
```

# Installing missing modules

```
sudo apt-get install rsyslog-mmjsonparse rsyslog-elasticsearch -y
```

```
sudo service rsyslog restart
```

# Verify daemon

```
grep rsyslogd /var/log/syslog
```

```
Feb 25 11:47:56 suricata rsyslogd: [origin software="rsyslogd" swVersion="7.4.4" x-pid="2499" x-info="http://www.rsyslog.com"] exiting on signal 15.
Feb 25 11:47:56 suricata rsyslogd: [origin software="rsyslogd" swVersion="8.16.0" x-pid="31019" x-info="http://www.rsyslog.com"] start
Feb 25 11:47:56 suricata rsyslogd-2307: warning: ~ action is deprecated, consider using the 'stop' statement instead [v8.16.0 try http://www.rsyslog.com/e/2307 ]
Feb 25 11:47:56 suricata rsyslogd: rsyslogd's groupid changed to 104
Feb 25 11:47:56 suricata rsyslogd: rsyslogd's userid changed to 101
```

# Simple filtering

```
vim /etc/rsyslog.d/60-suricata-tag-to-file.conf
```

```
if $syslogtag contains 'suricata' then /var/log/suricata-tag.log
```

# Filtering using JSON parser

```
vim /etc/rsyslog.d/61-suricata-cee-to-file.conf
```
```
module(load="mmjsonparse")

action(type="mmjsonparse")

if $parsesuccess == "OK" then action(
    type="omfile" 
    dirCreateMode="0700" 
    FileCreateMode="0644"
    File="/var/log/suricata-cee.log"
)
```

# Enable high precision timestamps

```
sudo vim /etc/rsyslog.conf
```
```
#$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
```
```
sudo service rsyslog restart
```

# Parsing syslog timestamp

```
template(name="suricata-index" type="list") {
    constant(value="suricata-") 
    property(name="timereported" dateFormat="rfc3339" position.from="1" position.to="4")
    constant(value=".") 
    property(name="timereported" dateFormat="rfc3339" position.from="6" position.to="7")
    constant(value=".") 
    property(name="timereported" dateFormat="rfc3339" position.from="9" position.to="10")
}
```

# Invoking a template for dynamic naming

```
local5.info     action(
    type="omfile"
    dirCreateMode="0700"
    FileCreateMode="0644"
    DynaFile="suricata-index"
)
```

# Defining custom log message format

```
template(name="JSON" type="list") {
    property(name="$!all-json")
}
```

# Invoking elasticsearch output module

```
action(
    type="omelasticsearch"
    template="JSON"
    server="192.168.56.101"
    serverport="9200"
    searchIndex="suricata-index"
)
```