# set up Minions

## listen to the master



 * apt-get install salt...
 * set conf to master....

## push numbers out

see telegraf

```

METRICS_SERVER="$1"

INSTALL_DIR=/provision
TLGF=0.2.4

mkdir -p ${INSTALL_DIR}/telegraf
cd ${INSTALL_DIR}/telegraf
if [ ! -f "telegraf_${TLGF}_amd64.deb" ]; then
  echo "installing https://s3.amazonaws.com/get.influxdb.org/telegraf/telegraf_${TLGF}_amd64.deb"
  wget -q https://s3.amazonaws.com/get.influxdb.org/telegraf/telegraf_${TLGF}_amd64.deb
  if [ ! -f "telegraf_${TLGF}_amd64.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {telegaf: {status:ERROR, msg: missing telegraf_${TLGF}_amd64.deb}"
    exit -1
  fi
  sudo dpkg -i telegraf_${TLGF}_amd64.deb > /dev/null
else
  service telegraf stop
  echo "reconfiguring telegraf"
fi
sed -i -e 's,http://localhost,http://'${METRICS_SERVER}',g' /etc/opt/telegraf/telegraf.conf
sed -i -e 's,interval = "10s",interval = "1s",g' /etc/opt/telegraf/telegraf.conf
sed -i -e 's,flush_interval = "1s",flush_interval = "60s",g' /etc/opt/telegraf/telegraf.conf
service telegraf start

```

 ----

 [next : master](/suricata/day_2/SetUpMaster.md)
