# apt-get install suricata


### system information

```
root@secx:~# uname -a   
Linux secx 3.19.0-30-generic #34~14.04.1-Ubuntu SMP Fri Oct 2 22:09:39 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
```

### install

```
root@secx:~# apt-get install suricata
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following extra packages will be installed:
  libauthen-sasl-perl libencode-locale-perl libfile-listing-perl

...

Setting up suricata (1.4.7-1ubuntu1.1) ...
 * suricata disabled, please adjust the configuration to your needs
 * and then set RUN to 'yes' in /etc/default/suricata to enable it.
Setting up libwww-perl (6.05-2) ...
Setting up oinkmaster (2.0-4) ...
Processing triggers for libc-bin (2.19-0ubuntu6.6) ...
Processing triggers for ureadahead (0.100.0-16) ...
```

### version info

```
root@secx:~# suricata -V
This is Suricata version 1.4.7 RELEASE
```

### build info

```
root@secx:~# suricata --build-info
This is Suricata version 1.4.7 RELEASE
Features: NFQ PCAP_SET_BUFF LIBPCAP_VERSION_MAJOR=1 AF_PACKET HAVE_PACKET_FANOUT LIBCAP_NG LIBNET1.1 HAVE_HTP_URI_NORMALIZE_HOOK HAVE_HTP_TX_GET_RESPONSE_HEADERS_RAW PCRE_JIT HAVE_NSS HAVE_LUAJIT HAVE_LIBJANSSON
64-bits, Little-endian architecture
GCC version 4.8.2, C version 199901
  __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1
  __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2
  __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4
  __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8
compiled with -fstack-protector
compiled with _FORTIFY_SOURCE=2
compiled with libhtp 0.2.14, linked against 0.2.14
Suricata Configuration:
  AF_PACKET support:                       yes
  PF_RING support:                         no
  NFQueue support:                         yes
  IPFW support:                            no
  DAG enabled:                             no
  Napatech enabled:                        no
  Unix socket enabled:                     yes

  libnss support:                          yes
  libnspr support:                         yes
  libjansson support:                      yes
  Prelude support:                         yes
  PCRE jit:                                yes
  libluajit:                               yes
  libgeoip:                                no
  Non-bundled htp:                         yes
  Old barnyard2 support:                   no
  CUDA enabled:                            no

  Suricatasc install:                      yes

  Unit tests enabled:                      no
  Debug output enabled:                    no
  Debug validation enabled:                no
  Profiling enabled:                       no
  Profiling locks enabled:                 no

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

### stop it for now

```
root@secx:~# service suricata stop
Stopping suricata:  done.

```


### help

```
root@secx:~# suricata -h
Suricata 2.0.11
USAGE: suricata [OPTIONS] [BPF FILTER]

	-c <path>                            : path to configuration file
	-T                                   : test configuration file (use with -c)
	-i <dev or ip>                       : run in pcap live mode
	-F <bpf filter file>                 : bpf filter file
	-r <path>                            : run in pcap file/offline mode
	-q <qid>                             : run in inline nfqueue mode
	-s <path>                            : path to signature file loaded in addition to suricata.yaml settings (optional)
	-S <path>                            : path to signature file loaded exclusively (optional)
	-l <dir>                             : default log directory
	-D                                   : run as daemon
	-k [all|none]                        : force checksum check (all) or disabled it (none)
	-V                                   : display Suricata version
	-v[v]                                : increase default Suricata verbosity
	--list-app-layer-protos              : list supported app layer protocols
	--list-keywords[=all|csv|<kword>]    : list keywords implemented by the engine
	--list-runmodes                      : list supported runmodes
	--runmode <runmode_id>               : specific runmode modification the engine should run.  The argument
	                                       supplied should be the id for the runmode obtained by running
	                                       --list-runmodes
	--engine-analysis                    : print reports on analysis of different sections in the engine and exit.
	                                       Please have a look at the conf parameter engine-analysis on what reports
	                                       can be printed
	--pidfile <file>                     : write pid to this file
	--init-errors-fatal                  : enable fatal failure on signature init error
	--disable-detection                  : disable detection engine
	--dump-config                        : show the running configuration
	--build-info                         : display build information
	--pcap[=<dev>]                       : run in pcap mode, no value select interfaces from suricata.yaml
	--pcap-buffer-size                   : size of the pcap buffer value from 0 - 2147483647
	--af-packet[=<dev>]                  : run in af-packet mode, no value select interfaces from suricata.yaml
	--user <user>                        : run suricata as this user after init
	--group <group>                      : run suricata as this group after init
	--erf-in <path>                      : process an ERF file
	--unix-socket[=<file>]               : use unix socket to control suricata work
	--set name=value                     : set a configuration value


To run the engine with default configuration on interface eth0 with signature file "signatures.rules", run the command as:

suricata -c suricata.yaml -s signatures.rules -i eth0

```

### what is under /etc

```
root@secx:~# tree /etc/suricata/
/etc/suricata/
|-- classification.config
|-- reference.config
|-- rules
|   |-- botcc.portgrouped.rules
|   |-- botcc.rules
|   |-- BSD-License.txt
|   |-- ciarmy.rules
|   |-- classification.config
|   |-- compromised-ips.txt
|   |-- compromised.rules
|   |-- decoder-events.rules
|   |-- dns-events.rules
|   |-- drop.rules
|   |-- dshield.rules
|   |-- emerging-activex.rules
|   |-- emerging-attack_response.rules
|   |-- emerging-chat.rules
|   |-- emerging.conf
|   |-- emerging-current_events.rules
|   |-- emerging-deleted.rules
|   |-- emerging-dns.rules
|   |-- emerging-dos.rules
|   |-- emerging-exploit.rules
|   |-- emerging-ftp.rules
|   |-- emerging-games.rules
|   |-- emerging-icmp_info.rules
|   |-- emerging-icmp.rules
|   |-- emerging-imap.rules
|   |-- emerging-inappropriate.rules
|   |-- emerging-info.rules
|   |-- emerging-malware.rules
|   |-- emerging-misc.rules
|   |-- emerging-mobile_malware.rules
|   |-- emerging-netbios.rules
|   |-- emerging-p2p.rules
|   |-- emerging-policy.rules
|   |-- emerging-pop3.rules
|   |-- emerging-rpc.rules
|   |-- emerging-scada.rules
|   |-- emerging-scan.rules
|   |-- emerging-shellcode.rules
|   |-- emerging-smtp.rules
|   |-- emerging-snmp.rules
|   |-- emerging-sql.rules
|   |-- emerging-telnet.rules
|   |-- emerging-tftp.rules
|   |-- emerging-trojan.rules
|   |-- emerging-user_agents.rules
|   |-- emerging-voip.rules
|   |-- emerging-web_client.rules
|   |-- emerging-web_server.rules
|   |-- emerging-web_specific_apps.rules
|   |-- emerging-worm.rules
|   |-- files.rules
|   |-- gen-msg.map
|   |-- gpl-2.0.txt
|   |-- http-events.rules
|   |-- LICENSE
|   |-- rbn-malvertisers.rules
|   |-- rbn.rules
|   |-- reference.config
|   |-- sid-msg.map
|   |-- smtp-events.rules
|   |-- stream-events.rules
|   |-- suricata-1.2-prior-open.yaml
|   |-- suricata-open.txt
|   |-- tls-events.rules
|   |-- tor.rules
|   `-- unicode.map
`-- suricata.yaml

1 directory, 69 files
```

### what was logged

```
root@secx:~# tree /var/log/suricata/
/var/log/suricata/
|-- certs
|-- core
|-- eve.json
|-- fast.log
|-- files
|-- http.log
|-- stats.log
|-- suricata-start.log
`-- unified2.alert.1452070536

3 directories, 6 files
```
