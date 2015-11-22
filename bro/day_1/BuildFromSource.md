# Building Bro from source

see https://www.bro.org/sphinx/install/install.html#installing-from-source

### Dependencies

```
apt-get install \
cmake \
make \
gcc \
g++ \
flex \
bison \
libpcap-dev \
libgeoip-dev \
libssl-dev \
python-dev \
zlib1g-dev \
libmagic-dev \
swig2.0 \
```


### get the source
```
git clone --recursive git://git.bro.org/bro
```


### configure, make install



```
./configure
```

```
make
```

```
sudo make install
```
