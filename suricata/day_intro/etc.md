## what is under /etc

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

----

[next: /var/log/suricata/*](/suricata/day_intro/log.md)

[jump to: configuration](/suricata/day_intro/BasicConf.md)
