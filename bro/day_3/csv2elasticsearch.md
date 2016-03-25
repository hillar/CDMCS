# CSV 2 ELASTIC

> on your manager box as user root

1. pip install csv2es
1. csv2es --help
1. mkdir -p /home/yellow/tmp
1. cd /home/yellow/tmp/
1. zcat /opt/bro/logs/2016-03-16/known_services.2* | head
1. zcat /opt/bro/logs/2016-03-16/known_services.22\:05\:17-23\:00\:00.log.gz > test.csv
1. head test.csv
1. vi test.csv
1. csv2es --host http://10.242.11.XX0:9200/ --tab --delete-index --index-name known --doc-type known_services --import-file  test.csv
1. open http://10.242.11.XX0:9200/_plugin/head


see
* https://github.com/search?utf8=%E2%9C%93&q=csv+json+elasticsearch
* http://www.codedependant.net/2012/04/12/handling-large-files-with-nodejs-and-elastic-searc/

> Now an often over looked fact when dealing with IO is that, typically, computers can read files much faster than they can write a file.

----


curl -XPOST "http://10.242.11.180:9200/known/_search?pretty" -d'
{
   "size": 0,
   "aggregations": {
      "service": {
         "terms": {
            "field": "service"          
         },
         "aggs": {
            "servers": {
              "terms": {
                "field": "host"
              }
          }
        }         
      }
   }
}'
