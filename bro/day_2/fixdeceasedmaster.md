# fix deceased master ;(

```
ssh someuser@192.168.1.2 'sudo service salt-minion stop; sudo rm -rf /etc/salt/pki /var/cache/salt /var/run/salt; sudo service salt-minion start;'
```
