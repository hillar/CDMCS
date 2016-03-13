# Adding Bro node

* https://help.ubuntu.com/community/SSH/OpenSSH/Keys

# All nodes

## User creation

```
useradd bro -N
```

```
useradd --help
```

## Setting home directory

```
usermod -d /opt/bro bro
```

## Create SSH key directory in user home

```
mkdir /opt/bro/.ssh
chown -R bro:bro /opt/bro
chmod 750 /opt/bro/.ssh
```

## Configure SSH public key

```
echo "<master public key>" > /opt/bro/.ssh/authorized_keys
```

# Master

## Execute command as another user

```
su - bro -s /bin/bash -c 'whoami'
```

## Generate SSH keys

```
ssh-keygen -t rsa -f /opt/bro/.ssh/id_rsa
```

## View rsa public key

```
cat /opt/bro/.ssh/id_rsa.pub
```

## Store SSH fingerprints

### Lazy admin

```
vim /opt/bro/.ssh/config
```
```
Host 192.168.0.*
    StrictHostKeyChecking no
```

### Proper way

```
ssh-keyscan 192.168.56.111 192.168.56.112 192.168.56.113 > /opt/bro/.ssh/known_hosts
```

### Deploy bro configuration

```
su - bro -s /bin/bash -c '/opt/bro/bin/broctl deploy'
```