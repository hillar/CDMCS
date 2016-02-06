# elasticsearch

see
* https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html
* https://www.elastic.co/guide/en/elasticsearch/reference/2.2/modules-node.html
* https://www.elastic.co/guide/en/elasticsearch/reference/2.2/modules-http.html#_disable_http


1. master :: node.master=true, node.data=false, http.enabled=true
1. data :: node.master=false, node.data=true, http.enabled=false
1. client :: node.master=false, node.data=false, http.enabled=true

```

wget -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-2.2.0.deb

dpkg -i elasticsearch-${ES}.deb

service elasticsearch stop

/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head

vi /ets/elasticsearch/elasticsearch.yml

service elasticsearch start


```
