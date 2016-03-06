# Configuration

> These are the basic configuration changes to make for a minimal BroControl installation that will manage a single Bro instance on the localhost:

>In $PREFIX/etc/node.cfg, set the right interface to monitor.
>In $PREFIX/etc/networks.cfg, comment out the default settings and add the networks that Bro will consider local to the monitored environment.
>In $PREFIX/etc/broctl.cfg, change the MailTo email address to a desired recipient and the LogRotationInterval to a desired log archival frequency.

* https://www.bro.org/sphinx/quickstart/index.html#a-minimal-starting-configuration
