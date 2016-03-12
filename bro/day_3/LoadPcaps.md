# Load Pcaps (...or bash for loop 101)

* https://www.bro.org/sphinx-git/frameworks/logging.html
* https://www.bro.org/bro-exchange-2013/exercises/faf.html
* [In case you have a lot of large pcaps](/bro/day_3/threadHack.sh)

```
1449511310.447338 warning in /usr/local/bro/share/bro/base/misc/find-checksum-offloading.bro, line 54: Your trace file likely has invalid TCP checksums, most likely from NIC checksum offloading.  By default, packets with invalid checksums are discarded by Bro unless using the -C command-line option or toggling the 'ignore_checksums' variable.  Alternatively, disable checksum offloading by the network adapter to ensure Bro analyzes the actual checksums that are transmitted.
```

## Fix this issue

```
WARNING: No Site::local_nets have been defined.  It's usually a good idea to define your local networks.
```