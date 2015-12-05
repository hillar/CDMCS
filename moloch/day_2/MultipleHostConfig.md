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

 * set config


 ```

 # /${TDIR}/elasticsearch-${ES}/etc/elasticsearch.yml

cluster.name: Moloch1

node.name: "${ES_HOSTNAME}"
node.max_local_storage_nodes: 2

index.fielddata.cache: node
indices.fielddata.cache.size: 40%
http.compression: true

bootstrap.mlockall: true

gateway.type: local
gateway.recover_after_nodes: 20
gateway.recover_after_time: 5m
gateway.expected_nodes: 20

discovery.zen.minimum_master_nodes: 4
discovery.zen.ping.multicast.enabled: false
discovery.zen.ping.unicast.hosts: ["node1", "node2", "node3", "node4"]

 ```


 * start


 ```
 #!/bin/sh
 TDIR=/opt/elasticsearch
 ES=1.7.3
 ES_HEAP_SIZE=20G

cd /${TDIR}/elasticsearch-${ES}
ulimit -a
export JAVA_OPTS="-XX:+UseCompressedOops"
export ES_HOSTNAME=`hostname -s`a
ES_HEAP_SIZE=${ES_HEAP_SIZE} bin/elasticsearch -Des.config=/srv/moloch/elasticsearch.yml
sleep 2
export ES_HOSTNAME=`hostname -s`b
ES_HEAP_SIZE=${ES_HEAP_SIZE} bin/elasticsearch -Des.config=/${TDIR}/elasticsearch-${ES}/etc/elasticsearch.yml

 ```
