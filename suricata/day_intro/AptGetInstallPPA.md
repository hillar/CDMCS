# apt-get install from PPA

### add PPA

 * on debian add backports, see http://blog.inliniac.net/2015/01/08/suricata-has-been-added-to-debian-backports/

```
root@secx:~# add-apt-repository ppa:oisf/suricata-stable
 Suricata IDS/IPS/NSM stable packages
http://www.openinfosecfoundation.org/
http://planet.suricata-ids.org/
http://suricata-ids.org/

Suricata IDS/IPS/NSM - Suricata is a high performance Intrusion Detection and Prevention System and Network Security Monitoring engine.

Open Source and owned by a community run non-profit foundation, the Open Information Security Foundation (OISF). Suricata is developed by the OISF, its supporting vendors and the community.

This Engine supports:

Multi-Threading - provides for extremely fast and flexible operation on multicore systems.
File Extraction, MD5 matching - over 4000 file types recognized and extracted from live traffic.
TLS/SSL certificate matching/logging
IEEE 802.1ad (QinQ) and IEEE 802.1Q (VLAN) support
All JSON output/logging capability
NSM runmode
Automatic Protocol Detection (IPv4/6, TCP, UDP, ICMP, HTTP, TLS, FTP, SMB, DNS )
Gzip Decompression
Fast IP Matching
Hardware acceleration on CUDA GPU cards
Lua scripting

and many more great features -
http://suricata-ids.org/features/all-features/
 More info: https://launchpad.net/~oisf/+archive/ubuntu/suricata-stable
Press [ENTER] to continue or ctrl-c to cancel adding it

gpg: keyring `/tmp/tmpttqnl7tx/secring.gpg' created
gpg: keyring `/tmp/tmpttqnl7tx/pubring.gpg' created
gpg: requesting key 66EB736F from hkp server keyserver.ubuntu.com
gpg: /tmp/tmpttqnl7tx/trustdb.gpg: trustdb created
gpg: key 66EB736F: public key "Launchpad PPA for Peter Manev" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
OK

```

### update

```
root@secx:~# apt-get update

...

Get:1 http://archive.ubuntu.com trusty-backports InRelease [64.5 kB]           
Hit http://security.ubuntu.com trusty-security InRelease                      
Hit http://security.ubuntu.com trusty-security/main Sources                    
Hit http://security.ubuntu.com trusty-security/universe Sources         
Get:2 http://archive.ubuntu.com trusty-backports/main amd64 Packages [9402 B]
Hit http://security.ubuntu.com trusty-security/main amd64 Packages             
Get:3 http://archive.ubuntu.com trusty-backports/restricted amd64 Packages [28 B]
Hit http://security.ubuntu.com trusty-security/universe amd64 Packages         
Get:4 http://archive.ubuntu.com trusty-backports/universe amd64 Packages [39.6 kB]
Hit http://security.ubuntu.com trusty-security/main Translation-en             
Get:5 http://archive.ubuntu.com trusty-backports/multiverse amd64 Packages [1571 B]
Hit http://security.ubuntu.com trusty-security/universe Translation-en         
Get:6 http://archive.ubuntu.com trusty-backports/main Translation-en [5549 B]
Get:7 http://archive.ubuntu.com trusty-backports/multiverse Translation-en [1215 B]
Get:8 http://archive.ubuntu.com trusty-backports/restricted Translation-en [14 B]
Get:9 http://archive.ubuntu.com trusty-backports/universe Translation-en [34.5 kB]
Fetched 156 kB in 6s (23.2 kB/s)                                               
Reading package lists... Done

```

### install

```

root@secx:~# apt-get install suricata
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following extra packages will be installed:
  libhtp1 libjansson4 libjs-jquery libluajit-5.1-2 libluajit-5.1-common

...

Setting up suricata (2.0.11-0ubuntu1) ...
Download and install the latest Emerging Threats Open ruleset

Downloading...
Latest ET Open rule set deployed in /etc/suricata/rules !
Starting suricata in IDS (af-packet) mode... done.
Processing triggers for libc-bin (2.19-0ubuntu6.6) ...
Processing triggers for ureadahead (0.100.0-16) ...

```

### version info

```
root@secx:~# suricata -V
This is Suricata version 2.0.11 RELEASE

```

### build info

```

root@secx:~# suricata --build-info
This is Suricata version 2.0.11 RELEASE
Features: NFQ PCAP_SET_BUFF LIBPCAP_VERSION_MAJOR=1 AF_PACKET HAVE_PACKET_FANOUT LIBCAP_NG LIBNET1.1 HAVE_HTP_URI_NORMALIZE_HOOK PCRE_JIT HAVE_NSS HAVE_LUA HAVE_LUAJIT HAVE_LIBJANSSON
SIMD support: none
Atomic intrisics: 1 2 4 8 byte(s)
64-bits, Little-endian architecture
GCC version 4.8.4, C version 199901
compiled with -fstack-protector
compiled with _FORTIFY_SOURCE=2
L1 cache line size (CLS)=64
compiled with LibHTP v0.5.18, linked against LibHTP v0.5.18
Suricata Configuration:
  AF_PACKET support:                       yes
  PF_RING support:                         no
  NFQueue support:                         yes
  NFLOG support:                           no
  IPFW support:                            no
  DAG enabled:                             no
  Napatech enabled:                        no
  Unix socket enabled:                     yes
  Detection enabled:                       yes

  libnss support:                          yes
  libnspr support:                         yes
  libjansson support:                      yes
  Prelude support:                         no
  PCRE jit:                                yes
  LUA support:                             yes
  libluajit:                               yes
  libgeoip:                                yes
  Non-bundled htp:                         yes
  Old barnyard2 support:                   no
  CUDA enabled:                            no

  Suricatasc install:                      yes

  Unit tests enabled:                      no
  Debug output enabled:                    no
  Debug validation enabled:                no
  Profiling enabled:                       no
  Profiling locks enabled:                 no
  Coccinelle / spatch:                     no

Generic build parameters:
  Installation prefix (--prefix):          /usr
  Configuration directory (--sysconfdir):  /etc/suricata/
  Log directory (--localstatedir) :        /var/log/suricata/

  Host:                                    x86_64-pc-linux-gnu
  GCC binary:                              gcc
  GCC Protect enabled:                     yes
  GCC march native enabled:                no
  GCC Profile enabled:                     no

```

### is it running ?

```
root@secx:~# service suricata status
suricata is running with PID 8316
```

### default configuration when started as a service?
```
root@secx:/etc/suricata# grep -A 9 'SURCONF' /etc/default/suricata 
SURCONF=/etc/suricata/suricata.yaml

# Listen mode: pcap, nfqueue or af-packet
# depending on this value, only one of the two following options
# will be used (af-packet uses neither).
# Please note that IPS mode is only available when using nfqueue
LISTENMODE=af-packet

# Interface to listen on (for pcap mode)
IFACE=eth0
```

### stop it for now

```
root@secx:~# service suricata stop
Stopping suricata:  done.

```

### start it "manually"

```
root@secx:~# suricata -c /etc/suricata/suricata.yaml -i eth0 -v
```
* http://pevma.blogspot.se/2013/12/suri-20beta2-very-informative-when-you.html

----

[next: help](/suricata/day_intro/help.md)
