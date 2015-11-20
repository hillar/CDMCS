# Moloch

[owl]: http://molo.ch/moloch_2x2.png

## http://molo.ch/

> Moloch is an open source, large scale IPv4 packet capturing (PCAP), indexing and database system. A simple web interface is provided for PCAP browsing, searching, and exporting. APIs are exposed that allow PCAP data and JSON-formatted session data to be downloaded directly. Simple security is implemented by using HTTPS and HTTP digest password support or by using apache in front. Moloch is not meant to replace IDS engines but instead work along side them to store and index all the network traffic in standard PCAP format, providing fast access. Moloch is built to be deployed across many systems and can scale to handle multiple gigabits/sec of traffic.

## https://github.com/aol/moloch

> The Moloch system is comprised of 3 components

> * **capture** - A single-threaded C application that runs per network interface. It is possible to run multiple capture processes per machine if there are multiple interfaces to monitor.
> * **viewer** - A node.js application that runs per capture machine and handles the web interface and transfer of PCAP files.
> * **elasticsearch** - The search database technology powering Moloch.


> Impatient

> git clone https://github.com/aol/moloch.git
> cd moloch
> ./easybutton-singlehost.sh
