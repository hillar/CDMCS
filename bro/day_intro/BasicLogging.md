# Logging

> Once Bro has been deployed in an environment and monitoring live traffic, it will, in its default configuration, begin to produce human-readable ASCII logs. Each log file, produced by Bro’s Logging Framework, is populated with organized, mostly connection-oriented data. As the standard log files are simple ASCII data, working with the data contained in them can be done from a command line terminal once you have been familiarized with the types of data that can be found in each file.


https://www.bro.org/sphinx/logs/index.html
https://www.bro.org/bro-workshop-2011/solutions/logs/

# Daemon logs

```
grep log /opt/bro/etc/broctl.cfg
```

## Log archive

```
root@bro-empty:/opt/bro/etc# ls -la <LOGDIR>
total 12
drwxrws--- 3 root bro  4096 Mar  8 14:20 .
drwxr-xr-x 8 root root 4096 Mar  8 14:01 ..
drwxr-sr-x 2 root bro  4096 Mar  8 14:20 2016-03-08
lrwxrwxrwx 1 root bro    18 Mar  8 14:17 current -> /opt/bro/spool/bro
```

## Actively written logs

```
ls -la /opt/bro/spool/bro
```

# Runtime

```
mkdir /tmp/logdir
cd /tmp/logdir && /opt/bro/bin/bro -r <pcapfile> local
tail *.log
```

# ASCII tools


 ```
/opt/bro/bin/bro-cut --help
/opt/bro/bin/bro-cut service resp_bytes id.resp_h < /opt/bro/logs/current/conn.log
 ```

# Log types

 * [conn](https://www.bro.org/sphinx/scripts/base/protocols/conn/main.bro.html)
 * [dns](https://www.bro.org/sphinx/scripts/base/protocols/dns/main.bro.html)
 * [http](https://www.bro.org/sphinx/scripts/base/protocols/http/main.bro.html)
 * [tls](https://www.bro.org/sphinx/scripts/base/files/x509/main.bro.html)
 * [smtp](https://www.bro.org/sphinx/scripts/base/protocols/smtp/main.bro.html)
 * [notice](https://www.bro.org/sphinx/scripts/base/frameworks/notice/main.bro.html)
 * [weird](https://www.bro.org/sphinx/scripts/base/frameworks/notice/weird.bro.html)
 * [etc...](https://www.bro.org/sphinx/script-reference/scripts.html)