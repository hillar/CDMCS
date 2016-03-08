# Basic configuration

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

# Broccoli?