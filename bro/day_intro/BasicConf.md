# Configuration

> These are the basic configuration changes to make for a minimal BroControl installation that will manage a single Bro instance on the localhost:

>In $PREFIX/etc/node.cfg, set the right interface to monitor.
>In $PREFIX/etc/networks.cfg, comment out the default settings and add the networks that Bro will consider local to the monitored environment.
>In $PREFIX/etc/broctl.cfg, change the MailTo email address to a desired recipient and the LogRotationInterval to a desired log archival frequency.

* https://www.bro.org/sphinx/quickstart/index.html#a-minimal-starting-configuration

```
root@bro-empty:/opt/bro/etc# ls -la /opt/bro/etc/
total 24
drwxrwsr-x 2 root bro  4096 Mar  8 14:01 .
drwxr-xr-x 8 root root 4096 Mar  8 14:01 ..
-rw-rw-r-- 1 root bro  2272 Sep  6  2015 broccoli.conf
-rw-rw-r-- 1 root bro  2611 Sep  8 17:33 broctl.cfg
-rw-rw-r-- 1 root bro   225 Sep  6  2015 networks.cfg
-rw-rw-r-- 1 root bro   644 Sep  6  2015 node.cfg
```

# Home networks

```
cat /opt/bro/etc/networks.cfg
```

# Listening interface

```
grep 'interface' -B4 /opt/bro/etc/node.cfg
```

# Notifications, log rotation, directories

```
vim /opt/bro/etc/broctl.cfg
```

---
# BroControl

Start up BroControl from the bin directory

```
<PREFIX>/bin/broctl
```

The first time that you run BroControl, you must install the BroControl configuration
```
[BroControl] > install
```

To see help:
```
[BroControl] > help
```

## Tasks
* Start a Bro instance and check if it is running.
* Find out which nodes are running. Which interfaces are monitored?
* What is the current packet count of the node?
* Find all Bro processes running.
* What type is your Bro instance?
* Print and examine the current broctl configuration
* Stop Bro and check if it has stopped.

