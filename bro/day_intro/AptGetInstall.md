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