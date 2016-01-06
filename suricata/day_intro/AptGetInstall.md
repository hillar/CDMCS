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

----

[next: add PPA](AppGetinstallPPA.md)
