# elasticsearch

see
* https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html
* https://www.elastic.co/guide/en/elasticsearch/reference/2.2/modules-node.html


1. master :: node.master=true, node.data=false, http.enabled=true
1. data :: node.master=false, node.data=true, http.enabled=false
1. client :: node.master=false, node.data=false, http.enabled=true
