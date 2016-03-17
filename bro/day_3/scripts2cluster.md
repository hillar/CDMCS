# load your custom script to cluster

> Local policy scripts are located in share/bro/site. In the stand-alone setup, a single file called local.bro gets loaded automatically. In the cluster setup, the same local.bro gets loaded, followed by one of three other files: local-manager.bro, local-worker.bro, and local-proxy.bro are loaded by the manager, workers, and proxy, respectively.


1. su - bro -s /bin/bash -c 'bin/broctl start'
1. su - bro -s /bin/bash -c 'bin/broctl status'
1. su - bro -s /bin/bash -c 'bin/broctl check'
1. vi /opt/bro/share/bro/site/local.bro
1. su - bro -s /bin/bash -c 'bin/broctl check'
1. su - bro -s /bin/bash -c 'bin/broctl update'
1. su - bro -s /bin/bash -c 'bin/broctl status'
1. mkdir /opt/bro/customscripts
1. cd /opt/bro/customscripts
1. wget ....
1. vi /opt/bro/share/bro/site/local.bro
1. su - bro -s /bin/bash -c 'bin/broctl check'
1. su - bro -s /bin/bash -c 'bin/broctl update'
1. su - bro -s /bin/bash -c 'bin/broctl status'
