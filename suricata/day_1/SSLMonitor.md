# SSL Monitor

see

* https://www.stamus-networks.com/2015/07/24/finding-self-signed-tls-certificates-suricata-and-luajit-scripting/
* https://resources.sei.cmu.edu/asset_files/Presentation/2016_017_001_449890.pdf

TLS Logging Example

```json

{
    "timestamp": "2016-01-06T11:20:31.431359+0100",
    "flow_id": 105716325071680,
    "
    in_iface ":"
    eth0 ","
    event_type ":"
    tls ","
    src_ip ":"
    192.168 .1 .6 ","
    src_port ":48952,"
    dest_ip ":"
    173.194 .65 .132 ","
    dest_port ":443,"
    proto ":"
    TCP ","
    tls ":{"
    subject ":"
    C = US,
    ST = California,
    L = Mountain View,
    O = Google Inc,
    CN = * .googleusercontent.com ",
    "issuerdn": "C=US, O=Google Inc, CN=Google Internet Authority G2",
    "fingerprint": "
    b2: e7: 5 a: d1: e4: 3 a: a9: a8: 37: f5: 13: b0: 1 a: 88: 70: a2: 60: fe: 8 a: 4 a ", "
    sni ":"
    lh3.
    googleusercontent.com ","
    version ":"
    TLS 1.2 "}}

```
