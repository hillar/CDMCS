[Getting started with Rsyslog](/common/rsyslogBasics.md)

# Invoking file input module

```
vim /etc/rsyslog.d/70-bro.conf
```

## Old syntax

```
$ModLoad imfile #
$InputFileName /usr/local/bro/logs/current/conn.log
$InputFileTag bro_conn:
$InputFileStateFile stat-bro_conn
$InputFileSeverity info
$InputFileFacility local7
```

No wildcards for rsyslog!

```
service rsyslog restart
```

Activate the poller

```
$InputRunFileMonitor
```

Setting poller interval

```
$InputFilePollingInterval 1
```

## New syntax

```
module(load="imfile" PollingInterval="1") #needs to be done just once

# File 1
input(type="imfile"
      File="/usr/local/bro/logs/current/conn.log"
      Tag="bro_conn"
      Severity="info"
      Facility="local7")
```