# Flow Probe

Suricata keeps ‘flow’ records:

* bidirectional
* uses 5 or 7 tuple depending on VLAN support
* used for storing various ‘states’
* TCP tracking and reassembly
 * HTTP parsing
* Flow records are updated per packet
* Flow records time out

Flow output records:

* IP protocol, source, destination, source port, destination port
* packet count, bytes count
* start time stamp (first packet), end time stamp (last packet)
* L7 protocol as detected based on traffic content
* TCP
 * flags seen
 * state at flow end
