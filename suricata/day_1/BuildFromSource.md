# Building Suricata from source

see https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Installation_from_GIT

### get the source

git clone git://phalanx.openinfosecfoundation.org/oisf.git
cd oisf
git clone https://github.com/OISF/libhtp.git -b 0.5.x

### configure, make install

./autogen.sh

./configure

make

sudo make install

sudo ldconfig
