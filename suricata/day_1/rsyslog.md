# Rsyslog

 * http://www.rsyslog.com/ubuntu-repository/

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