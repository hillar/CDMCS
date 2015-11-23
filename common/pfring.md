# PF RING


```
wget http://sourceforge.net/projects/ntop/files/PF_RING/PF_RING-6.0.3.tar.gz
tar xvzf PF_RING-6.0.3.tar.gz
cd PF_RING-6.0.3/
make
cd kernel
sudo make install
cd ../userland/lib
sudo make install



```




```
wget http://apt.ntop.org/14.04/all/apt-ntop.deb
sudo dpkg -i apt-ntop.deb
sudo apt-get clean all
sudo apt-get update
sudo apt-get install pfring 
```
