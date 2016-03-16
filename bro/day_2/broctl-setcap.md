# Fixing the setcap every time broctl deploys configuration to workers

## A: Install a broctl plugin that does it for you
see: https://github.com/PingTrip/broctl-setcap


## B: Workaround

Run all these commands after deploy or make into a "deploy" script for yourself

```
su - bro -s /bin/bash -c '/opt/bro/bin/broctl deploy'

# Even though workers crashed, to clean up, you should run 'stop' for workers
su - bro -s /bin/bash -c '/opt/bro/bin/broctl stop' 
salt "*$BROS*" cmd.run 'setcap "CAP_NET_RAW+eip" /opt/bro/bin/bro'
salt "*$BROS*" cmd.run 'setcap "CAP_NET_RAW+eip" /opt/bro/bin/capstats'
su - bro -s /bin/bash -c '/opt/bro/bin/broctl start' 
```

