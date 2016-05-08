# you got a pcap


```bash
for pcap in `find /srv/ -type f -name '*.pcap*'`; do echo "`tcpdump -r $pcap -c1 -tttt 2> /dev/null | perl -ne 'if (m/^(.+)\.\d+ IP/){print "$1"}'` : $pcap"  ; done >> /tmp/list_combined.txt
```

```bash
#!/bin/bash
echo "first;last;pcap"
for pcap in $(find /srv/ -type f -name '*.pcap*'|head);
do
  first=$(tcpdump -r $pcap -c1 -tt 2> /dev/null| cut -f1 -d".")
  last=$(tcpdump -r $pcap -tt 2> /dev/null|tail -1| cut -f1 -d".")
  echo "$first;$last;$pcap"
done
```

> tcpdump -r $pcap -tt 2> /dev/null|tail -1| cut -f1 -d"." <- is slow

```bash
#!/bin/bash

filename=$1

# for pcap in `find /srv/ -type f -name '*.pcap*'`; do echo "`tcpdump -r $pcap -c1 -tttt 2> /dev/null | perl -ne 'if (m/^(.+)\.\d+ IP/){print "$1"}'` : $pcap"  ; done >> filename


echo "# start $(date)" > /tmp/kala
line=$(wc -l $filename | cut -f1 -d" ")
while [[ "$line" != "0" ]] ; do
  tmp=$(head -1 $filename)
  time=$(echo $tmp | cut -f1,2 -d" "|sed 's/ //g'|sed 's/-//g'|sed 's/://g')
  file=$(echo $tmp | cut -f4 -d" ")
  log=$(echo $file| sed 's/\//_/g')
  sed -i '1d' $filename
  if [[ "$file" != "" ]];
  then
    i=$(pgrep moloch-capture | wc -l)
    echo "already running $i"
    while [[ "$i" > "2" ]]
    do
      sleep 5
      i=$(pgrep moloch-capture | wc -l)
      echo "$i"
    done
    echo "$time $file" >> /tmp/kala
    echo $file
    /data/moloch/bin/moloch-capture -c /data/moloch/etc/config.ini -r $file  > /tmp/log.$log 2>&1 &
    sleep 1
  fi
  line=$(wc -l $filename | cut -f1 -d" ")
  echo $line
done
echo "# end $(date)" >> /tmp/kala
```
