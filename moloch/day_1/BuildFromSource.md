# Build Moloch from source

see https://github.com/aol/moloch/blob/master/README.rst#building-and-installing

## Building Capture

### Dependencies

```
apt-get install \
wget \
curl \
libpcre3-dev \
uuid-dev \
libmagic-dev \
pkg-config \
g++ \
flex \
bison \
zlib1g-dev \
libffi-dev \
gettext \
libgeoip-dev \
make \
libjson-perl \
libbz2-dev \
libwww-perl \
libpng-dev \
xz-utils \
libffi-dev

```

```
wget http://ftp.gnome.org/pub/gnome/sources/glib/2.46/glib-2.46.2.tar.xz
./configure --disable-xattr --disable-shared --enable-static --disable-libelf --disable-selinux
```

```
wget http://yara-project.googlecode.com/files/yara-1.7.tar.gz
./configure --enable-static

```

```
wget http://www.maxmind.com/download/geoip/api/c/GeoIP-1.6.0.tar.gz
./configure --enable-static

```

```
wget http://www.tcpdump.org/release/libpcap-1.7.2.tar.gz
./configure --disable-dbus

```

```
wget http://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz
./configure --disable-libnet --disable-glib2

```

### 

```
git clone https://github.com/aol/moloch.git
cd moloch
make
```
