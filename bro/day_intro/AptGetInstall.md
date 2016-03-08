# Installing from repository

 * https://www.bro.org/download/packages.html

# Modify apt sources list file

Remember to edit the following line to reflect your Ubuntu version. I.e. package compiled for 14.10 will not work on 14.04.

```
echo 'deb http://download.opensuse.org/repositories/network:/bro/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/bro.list
```

You can verify with the following command.

```
cat /etc/lsb-release
```

# Add release key

```
wget http://download.opensuse.org/repositories/network:bro/xUbuntu_14.04/Release.key
sudo apt-key add - < Release.key
```

# Update package lists

```
apt-get update
```

# Install bro

```
apt-get -y install bro
```

# Verify APT package version

```
root@bro-empty:~# apt-cache policy bro
bro:
  Installed: 2.4.1-0
  Candidate: 2.4.1-0
  Version table:
 *** 2.4.1-0 0
        500 http://download.opensuse.org/repositories/network:/bro/xUbuntu_14.04/  Packages
        100 /var/lib/dpkg/status
```

# Deploy scripts and verify daemon

```
/opt/bro/bin/broctl deploy
```

```
/opt/bro/bin/broctl status
```

# Update only

```
/opt/bro/bin/broctl install
```

# RTFM

```
root@bro-empty:/opt/bro/etc# /opt/bro/bin/broctl help

BroControl Version 1.4

  capstats [<nodes>] [<secs>]      - Report interface statistics with capstats
  check [<nodes>]                  - Check configuration before installing it
  cleanup [--all] [<nodes>]        - Delete working dirs (flush state) on nodes
  config                           - Print broctl configuration
  cron [--no-watch]                - Perform jobs intended to run from cron
  cron enable|disable|?            - Enable/disable "cron" jobs
  deploy                           - Check, install, and restart
  df [<nodes>]                     - Print nodes' current disk usage
  diag [<nodes>]                   - Output diagnostics for nodes
  exec <shell cmd>                 - Execute shell command on all hosts
  exit                             - Exit shell
  install                          - Update broctl installation/configuration
  netstats [<nodes>]               - Print nodes' current packet counters
  nodes                            - Print node configuration
  peerstatus [<nodes>]             - Print status of nodes' remote connections
  print <id> [<nodes>]             - Print values of script variable at nodes
  process <trace> [<op>] [-- <sc>] - Run Bro (with options and scripts) on trace
  quit                             - Exit shell
  restart [--clean] [<nodes>]      - Stop and then restart processing
  scripts [-c] [<nodes>]           - List the Bro scripts the nodes will load
  start [<nodes>]                  - Start processing
  status [<nodes>]                 - Summarize node status
  stop [<nodes>]                   - Stop processing
  top [<nodes>]                    - Show Bro processes ala top
  update [<nodes>]                 - Update configuration of nodes on the fly
  
Commands provided by plugins:

  ps.bro [<nodes>]                 - Show Bro processes on nodes' systems
```