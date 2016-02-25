# Kibana4

 * https://www.elastic.co/products/kibana
 * https://www.elastic.co/guide/en/kibana/current/index.html
 * https://www.digitalocean.com/community/tutorials/how-to-use-kibana-dashboards-and-visualizations
 * http://www.lucenetutorial.com/lucene-query-syntax.html
 * https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations.html

## Config file

```
grep "elasticsearch.url" /opt/kibana/config/kibana.yml
```

## Lucene search syntax

```
event_type:"alert" AND alert.severity:2
```