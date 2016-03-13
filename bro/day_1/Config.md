# Single host configuration

```

# Home networks

```
cat /opt/bro/etc/networks.cfg
```

Do not forget IPv6!


# Listening interface

```
grep 'interface' -B4 /opt/bro/etc/node.cfg
```

# Working modes
* Standalone

* Clustered - also multithreading on a single host
https://www.bro.org/sphinx-git/cluster/index.html#on-host-flow-balancing

# Notifications, log rotation, directories

```
vim /opt/bro/etc/broctl.cfg
```

# Broccoli
BRO Client COmmunications LIbrary

https://www.bro.org/sphinx/components/broccoli/broccoli-manual.html


# BroControl
Remember to install broctl configuration.
See notes from [basic config](/bro/day_intro/BasicConf.md)

## Tasks
* Start a Bro instance and check if it is running.
* Find out which nodes are running?
* Which interfaces are monitored?
* What is the current packet count of the node?
* Find all running Bro processes.
* What type is your Bro instance?
* Try restarting the Bro instance.
* Stop Bro and check if it has stopped.

