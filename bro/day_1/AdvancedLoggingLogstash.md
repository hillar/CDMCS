# Advanced Logging

This page assumes an existing logstash installation from elastic repository

* https://www.elastic.co/guide/en/logstash/current/plugins-inputs-file.html
* https://www.elastic.co/guide/en/logstash/current/plugins-outputs-elasticsearch.html

# Locate logstash configuration directory

```
ls -la /etc/logstash/conf.d/
```

# View logstash daemon logs

```
tail -f /var/log/logstash/logstash.{err,log}
```

# Start and stop daemon

```
service logstash start
service logstash stop
```

Be patient!

# Verify logstash configuration

```
sudo -u logstash /opt/logstash/bin/logstash agent -f /etc/logstash/conf.d --configtest
```

# Verify logstash permissions

```
grep bro /etc/passwd && adduser logstash bro
```

```
ls -la /<broroot>/spool/bro
```

# Using the file input plugin

```
vim /etc/logstash/conf.d/10-bro.conf
```

```
input {
  file {
    type => "bro-conn_log"
    start_position => "end"
    sincedb_path => "/var/tmp/.bro_conn_sincedb"
    path => "/opt/bro/logs/current/conn.log"
  }
}
```

Or...

```
input {
  file {
    type => "bro_log"
    start_position => "end"
    path => "/opt/bro/logs/current/*.log"
  }
}
```

# Elasticsearch output

```
output {
  # stdout { codec => rubydebug }
  elasticsearch { 
    hosts => "127.0.0.1"
    index => "bro-%{+YYYY.MM.dd.HH}"
  }
}
```