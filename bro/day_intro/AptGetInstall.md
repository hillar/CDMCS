# Modify apt sources list file

Remember to edit the following line to reflect your Ubuntu version. I.e. package compiled for 14.10 will not work on 14.04.

```
echo 'deb http://download.opensuse.org/repositories/network:/bro/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/bro.list
```

You can verify with the following command.

```
cat /etc/lsb-release
```

# Update package lists

```
apt-get update
```

# Install bro

```
apt-get -y install bro
```