```
root@secx:~# suricata --list-runmodes
------------------------------------- Runmodes ------------------------------------------
| RunMode Type      | Custom Mode       | Description 
|----------------------------------------------------------------------------------------
| PCAP_DEV          | single            | Single threaded pcap live mode 
|                   ---------------------------------------------------------------------
|                   | autofp            | Multi threaded pcap live mode.  Packets from each flow are assigned to a single detect thread, unlike "pcap_live_auto" where packets from the same flow can be processed by any detect thread 
|                   ---------------------------------------------------------------------
|                   | workers           | Workers pcap live mode, each thread does all tasks from acquisition to logging 
|----------------------------------------------------------------------------------------
| PCAP_FILE         | single            | Single threaded pcap file mode 
|                   ---------------------------------------------------------------------
|                   | autofp            | Multi threaded pcap file mode.  Packets from each flow are assigned to a single detect thread, unlike "pcap-file-auto" where packets from the same flow can be processed by any detect thread 
|----------------------------------------------------------------------------------------
| PFRING(DISABLED)  | autofp            | Multi threaded pfring mode.  Packets from each flow are assigned to a single detect thread, unlike "pfring_auto" where packets from the same flow can be processed by any detect thread 
|                   ---------------------------------------------------------------------
|                   | single            | Single threaded pfring mode 
|                   ---------------------------------------------------------------------
|                   | workers           | Workers pfring mode, each thread does all tasks from acquisition to logging 
|----------------------------------------------------------------------------------------
| NFQ               | autofp            | Multi threaded NFQ IPS mode with respect to flow 
|                   ---------------------------------------------------------------------
|                   | workers           | Multi queue NFQ IPS mode with one thread per queue 
|----------------------------------------------------------------------------------------
| NFLOG             | autofp            | Multi threaded nflog mode   
|                   ---------------------------------------------------------------------
|                   | single            | Single threaded nflog mode  
|                   ---------------------------------------------------------------------
|                   | workers           | Workers nflog mode          
|----------------------------------------------------------------------------------------
| IPFW              | autofp            | Multi threaded IPFW IPS mode with respect to flow 
|                   ---------------------------------------------------------------------
|                   | workers           | Multi queue IPFW IPS mode with one thread per queue 
|----------------------------------------------------------------------------------------
| ERF_FILE          | single            | Single threaded ERF file mode 
|                   ---------------------------------------------------------------------
|                   | autofp            | Multi threaded ERF file mode.  Packets from each flow are assigned to a single detect thread 
|----------------------------------------------------------------------------------------
| ERF_DAG           | autofp            | Multi threaded DAG mode.  Packets from each flow are assigned to a single detect thread, unlike "dag_auto" where packets from the same flow can be processed by any detect thread 
|                   ---------------------------------------------------------------------
|                   | single            | Singled threaded DAG mode   
|                   ---------------------------------------------------------------------
|                   | workers           | Workers DAG mode, each thread does all  tasks from acquisition to logging 
|----------------------------------------------------------------------------------------
| AF_PACKET_DEV     | single            | Single threaded af-packet mode 
|                   ---------------------------------------------------------------------
|                   | workers           | Workers af-packet mode, each thread does all tasks from acquisition to logging 
|                   ---------------------------------------------------------------------
|                   | autofp            | Multi socket AF_PACKET mode.  Packets from each flow are assigned to a single detect thread. 
|----------------------------------------------------------------------------------------
| NETMAP(DISABLED)  | single            | Single threaded netmap mode 
|                   ---------------------------------------------------------------------
|                   | workers           | Workers netmap mode, each thread does all tasks from acquisition to logging 
|                   ---------------------------------------------------------------------
|                   | autofp            | Multi threaded netmap mode.  Packets from each flow are assigned to a single detect thread. 
|----------------------------------------------------------------------------------------
| UNIX_SOCKET       | single            | Unix socket mode            
|----------------------------------------------------------------------------------------
```

---

[next: configuration](/suricata/day_intro/BasicConf.md)

