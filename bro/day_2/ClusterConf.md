# BRO cluster Configuration

see https://www.bro.org/sphinx/cluster/index.html

https://www.bro.org/sphinx-git/configuration/index.html

![main parts of cluster](https://www.bro.org/sphinx/_images/deployment.png)

## manager host configuration

### <prefix>/etc/node.cfg
```
[manager]
type=manager
host=10.0.0.10

[proxy-1]
type=proxy
host=10.0.0.10

[worker-1]
type=worker
host=10.0.0.11
interface=eth0

[worker-2]
type=worker
host=10.0.0.12
interface=eth0
```

### <prefix>/etc/broctl.cfg
