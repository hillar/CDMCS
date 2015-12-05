# Multiple Host Configuration

see https://github.com/aol/moloch/wiki/Multiple-Host-HOWTO
https://github.com/aol/moloch/wiki/Architecture#multiple-hosts-monitoring-multiple-network-segments


## elasticsearch

 * install
```
echo "setting up elastic for $1"

TDIR=/opt/elasticsearch
INSTALL_DIR=/tmp
ES=1.7.3

# Java
apt-get -y -qq install openjdk-7-jdk

# ElasticSearch
mkdir -p TDIR
mkdir -p ${INSTALL_DIR}/thirdparty
echo "Downloading and installing elastic search"
cd ${INSTALL_DIR}/thirdparty
if [ ! -f "elasticsearch-${ES}.tar.gz" ]; then
  wget -q http://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ES}.tar.gz
fi
cd ${TDIR}
tar xfz ${INSTALL_DIR}/thirdparty/elasticsearch-${ES}.tar.gz
cd elasticsearch-${ES}
./bin/plugin -install mobz/elasticsearch-head

```

 * set up start/stop

 ```

 ```
