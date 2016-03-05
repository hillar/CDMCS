# Timing
## Emtpy
#### status
```bash
+ vagrant status
Current machine states:

empty                     not created (virtualbox)

The environment has not yet been created. Run `vagrant up` to
create the environment. If a machine is not created, only the
default provider will be shown. So if a provider is not listed,
then the machine is not created for that environment.

real	0m2.399s
user	0m2.110s
sys	0m0.184s
```
#### up
```bash
+ vagrant up
Bringing machine 'empty' up with 'virtualbox' provider...
==> empty: Importing base box 'ubu14'...
[KProgress: 90%[K==> empty: Matching MAC address for NAT networking...
==> empty: Setting the name of the VM: empty_empty_1457191967875_58638
==> empty: Clearing any previously set network interfaces...
==> empty: Preparing network interfaces based on configuration...
    empty: Adapter 1: nat
    empty: Adapter 2: hostonly
==> empty: Forwarding ports...
    empty: 22 (guest) => 2222 (host) (adapter 1)
==> empty: Running 'pre-boot' VM customizations...
==> empty: Booting VM...
==> empty: Waiting for machine to boot. This may take a few minutes...
    empty: SSH address: 127.0.0.1:2222
    empty: SSH username: vagrant
    empty: SSH auth method: private key
==> empty: Machine booted and ready!
==> empty: Checking for guest additions in VM...
    empty: The guest additions on this VM do not match the installed version of
    empty: VirtualBox! In most cases this is fine, but in rare cases it can
    empty: prevent things such as shared folders from working properly. If you see
    empty: shared folder errors, please make sure the guest additions within the
    empty: virtual machine match the version of VirtualBox you have installed on
    empty: your host and reload your VM.
    empty: 
    empty: Guest Additions Version: 4.3.34
    empty: VirtualBox Version: 5.0
==> empty: Setting hostname...
==> empty: Configuring and enabling network interfaces...
==> empty: Running provisioner: shell...
    empty: Running: inline script
==> empty: stdin: is not a tty
==> empty: eth0      Link encap:Ethernet  HWaddr 08:00:27:92:f5:d4  
==> empty:           inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
==> empty:           inet6 addr: fe80::a00:27ff:fe92:f5d4/64 Scope:Link
==> empty:           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
==> empty:           RX packets:441 errors:0 dropped:0 overruns:0 frame:0
==> empty:           TX packets:299 errors:0 dropped:0 overruns:0 carrier:0
==> empty:           collisions:0 txqueuelen:1000 
==> empty:           RX bytes:48421 (48.4 KB)  TX bytes:43416 (43.4 KB)
==> empty: 
==> empty: eth1      Link encap:Ethernet  HWaddr 08:00:27:35:77:ff  
==> empty:           inet addr:192.168.11.110  Bcast:192.168.11.255  Mask:255.255.255.0
==> empty:           inet6 addr: fe80::a00:27ff:fe35:77ff/64 Scope:Link
==> empty:           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
==> empty:           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
==> empty:           TX packets:2 errors:0 dropped:0 overruns:0 carrier:0
==> empty:           collisions:0 txqueuelen:1000 
==> empty:           RX bytes:0 (0.0 B)  TX bytes:168 (168.0 B)
==> empty: 
==> empty: lo        Link encap:Local Loopback  
==> empty:           inet addr:127.0.0.1  Mask:255.0.0.0
==> empty:           inet6 addr: ::1/128 Scope:Host
==> empty:           UP LOOPBACK RUNNING  MTU:65536  Metric:1
==> empty:           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
==> empty:           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
==> empty:           collisions:0 txqueuelen:0 
==> empty:           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
==> empty: PING www.ee (194.106.111.42) 56(84) bytes of data.
==> empty: 64 bytes from 194.106.111.42: icmp_seq=1 ttl=63 time=8.30 ms
==> empty: --- www.ee ping statistics ---
==> empty: 1 packets transmitted, 1 received, 0% packet loss, time 0ms
==> empty: rtt min/avg/max/mdev = 8.306/8.306/8.306/0.000 ms
==> empty: Active Internet connections (only servers)
==> empty: Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode       PID/Program name
==> empty: tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          10893       1682/sshd       
==> empty: tcp6       0      0 :::22                   :::*                    LISTEN      0          10895       1682/sshd       

real	0m36.906s
user	0m4.620s
sys	0m1.805s
```
#### destroy
```bash
+ vagrant destroy -f
==> empty: Forcing shutdown of VM...
==> empty: Destroying VM and associated drives...

real	0m4.630s
user	0m2.133s
sys	0m0.514s
```
## Dummy
#### status
```bash
+ vagrant status
Current machine states:

empty                     not created (virtualbox)

The environment has not yet been created. Run `vagrant up` to
create the environment. If a machine is not created, only the
default provider will be shown. So if a provider is not listed,
then the machine is not created for that environment.

real	0m2.355s
user	0m2.090s
sys	0m0.175s
```
#### up
```bash
+ vagrant up
Bringing machine 'empty' up with 'virtualbox' provider...
==> empty: Importing base box 'ubu14'...
[KProgress: 40%[KProgress: 90%[K==> empty: Matching MAC address for NAT networking...
==> empty: Setting the name of the VM: empty_empty_1457192012275_9690
==> empty: Clearing any previously set network interfaces...
==> empty: Preparing network interfaces based on configuration...
    empty: Adapter 1: nat
    empty: Adapter 2: hostonly
==> empty: Forwarding ports...
    empty: 22 (guest) => 2222 (host) (adapter 1)
==> empty: Running 'pre-boot' VM customizations...
==> empty: Booting VM...
==> empty: Waiting for machine to boot. This may take a few minutes...
    empty: SSH address: 127.0.0.1:2222
    empty: SSH username: vagrant
    empty: SSH auth method: private key
==> empty: Machine booted and ready!
==> empty: Checking for guest additions in VM...
    empty: The guest additions on this VM do not match the installed version of
    empty: VirtualBox! In most cases this is fine, but in rare cases it can
    empty: prevent things such as shared folders from working properly. If you see
    empty: shared folder errors, please make sure the guest additions within the
    empty: virtual machine match the version of VirtualBox you have installed on
    empty: your host and reload your VM.
    empty: 
    empty: Guest Additions Version: 4.3.34
    empty: VirtualBox Version: 5.0
==> empty: Setting hostname...
==> empty: Configuring and enabling network interfaces...
==> empty: Running provisioner: shell...
    empty: Running: inline script
==> empty: stdin: is not a tty
==> empty: eth0      Link encap:Ethernet  HWaddr 08:00:27:92:f5:d4  
==> empty:           inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
==> empty:           inet6 addr: fe80::a00:27ff:fe92:f5d4/64 Scope:Link
==> empty:           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
==> empty:           RX packets:462 errors:0 dropped:0 overruns:0 frame:0
==> empty:           TX packets:326 errors:0 dropped:0 overruns:0 carrier:0
==> empty:           collisions:0 txqueuelen:1000 
==> empty:           RX bytes:49681 (49.6 KB)  TX bytes:45558 (45.5 KB)
==> empty: 
==> empty: eth1      Link encap:Ethernet  HWaddr 08:00:27:da:cf:50  
==> empty:           inet addr:192.168.11.110  Bcast:192.168.11.255  Mask:255.255.255.0
==> empty:           inet6 addr: fe80::a00:27ff:feda:cf50/64 Scope:Link
==> empty:           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
==> empty:           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
==> empty:           TX packets:3 errors:0 dropped:0 overruns:0 carrier:0
==> empty:           collisions:0 txqueuelen:1000 
==> empty:           RX bytes:0 (0.0 B)  TX bytes:258 (258.0 B)
==> empty: 
==> empty: lo        Link encap:Local Loopback  
==> empty:           inet addr:127.0.0.1  Mask:255.0.0.0
==> empty:           inet6 addr: ::1/128 Scope:Host
==> empty:           UP LOOPBACK RUNNING  MTU:65536  Metric:1
==> empty:           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
==> empty:           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
==> empty:           collisions:0 txqueuelen:0 
==> empty:           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
==> empty: PING www.ee (194.106.111.42) 56(84) bytes of data.
==> empty: 64 bytes from 194.106.111.42: icmp_seq=1 ttl=63 time=8.85 ms
==> empty: --- www.ee ping statistics ---
==> empty: 1 packets transmitted, 1 received, 0% packet loss, time 0ms
==> empty: rtt min/avg/max/mdev = 8.857/8.857/8.857/0.000 ms
==> empty: Active Internet connections (only servers)
==> empty: Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode       PID/Program name
==> empty: tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          10682       1684/sshd       
==> empty: tcp6       0      0 :::22                   :::*                    LISTEN      0          10684       1684/sshd       

real	0m37.435s
user	0m4.678s
sys	0m1.821s
```
#### destroy
```bash
+ vagrant destroy -f
==> empty: Forcing shutdown of VM...
==> empty: Destroying VM and associated drives...

real	0m4.864s
user	0m2.233s
sys	0m0.553s
```
