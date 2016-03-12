#!/bin/bash

thread_hack() {
  logdir=$1
  filepath=$2
  count_cmd=$(pgrep -c bro)
  threads_max=`grep '^core id' /proc/cpuinfo | wc -l`
  echo $logdir
  if [ $count_cmd -lt $threads_max ] ; then
    echo "Processing $filepath"
    if [ ! -d $logdir ]; then echo "$logdir does not exist. Creating"; mkdir -p $logdir; fi
    cd $logdir && $BROBIN -r $filepath local &
  else
    echo "Sleeping"
    sleep 1
    thread_hack $logdir $filepath
  fi
}
BASEDIR=/vagrant/pcap/
DESTDIR=/vagrant/log/

BROBIN='/usr/local/bro/bin/bro'

export LANG=C
export LC_ALL=C

mkdir -p $DESTDIR

for pcap_path in `find $BASEDIR -type f -name '*.pcap'`; do
  pcap_log_dir="$DESTDIR/`echo $pcap_path | perl -ne 'if (m/.+\/([\d\w-]+)\.pcap/){ print "$1\n"; } '`"
  thread_hack $pcap_log_dir $pcap_path
done