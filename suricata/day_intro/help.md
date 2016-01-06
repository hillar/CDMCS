## help

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

----

[next: /etc/suricata/*](/suricata/day_intro/etc.md)
