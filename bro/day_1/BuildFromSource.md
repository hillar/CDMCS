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

### libcaf

> Robin Sommer | 22 Jul 21:39 2015

> Re: Build Errors - Libcaf

> On Wed, Jul 22, 2015 at 12:06 -0700, anthony kasza wrote:
>> I'm building Bro from source and am receiving cmake errors "Could NOT find
>> Libcaf". Is this a requirement to build Bro now?

>Yes, since last night. :)

```
wget https://github.com/actor-framework/actor-framework/archive/0.14.4.tar.gz
tar -xzf 0.14.4.tar.gz
cd actor-framework-0.14.4/
./configure --no-examples
make
make install
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
...
make[1]: Leaving directory `/root/bro/build'

real	15m11.303s
user	13m46.980s
sys	1m19.839s
```

```
sudo make install
```

```
/usr/local/bro/bin/bro -v
version 2.4-313
```
