# Advanced Logging

This page assumes an existing logstash installation from elastic repository

* https://www.elastic.co/guide/en/logstash/current/plugins-inputs-file.html
* https://www.elastic.co/guide/en/logstash/current/plugins-outputs-elasticsearch.html
* https://www.elastic.co/guide/en/logstash/current/plugins-filters-json.html
* https://www.elastic.co/guide/en/elasticsearch/reference/current/breaking_20_mapping_changes.html
* https://www.elastic.co/guide/en/logstash/current/plugins-filters-de_dot.html
* https://www.elastic.co/guide/en/logstash/current/plugins-filters-mutate.html
* https://www.elastic.co/guide/en/logstash/current/plugins-filters-date.html

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

# Opening the JSON

```
filter {
  json {
    source => "message"
  }
}
```

If statements are your friends...

filter {
  if type == "bro_log" {
    json {
      source => "message"
    }
  }
}

# Normalizing field names

## Easy but expensive

```
de_dot {}
```

## Might be better

```
mutate {
  gsub => [
    "message", "id\.orig_h", "id_orig_h",
    "message", "id\.resp_h", "id_resp_h",
    "message", "id\.orig_p", "id_orig_p",
    "message", "id\.resp_p", "id_resp_p"
  ]
}
```

# Timestamping for Kibana

## Quick and dirty

```
  date {
    match => [ "ts", "UNIX" ]
  }
```

## Challenge - use Bro and Elasticsearch

* https://www.bro.org/sphinx-git/scripts/base/init-bare.bro.html#type-JSON::TimestampFormat
* https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-date-format.html
* https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html
* [Bro ES template - with syntax error](/bro/day_1/bro.json)
* [Bro ES template - working](/bro/day_1/bro2.json)
