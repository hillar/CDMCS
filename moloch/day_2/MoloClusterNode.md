# ElasticSearch cluster nodes

## looping over vm's
```
HOSTS = {
   #[count, cpu, mem,  provision_scripts ]
   # ! sum of count must be less than 10
   # you can have more than one script per vm ;)
   "elastic" => [4,4,16,[$dummy, $elastic]],
   "capture" => [3,4,4,[$dummy]],
   "viever" => [2,2,1,[$dummy]],
}

...

counter = 1
  (1..TEAMS).each do |teamnumber|
    inteam = 0
    HOSTS.each do | (_name, cfg) |
      boxcount, cpu, mem, scripts = cfg
      (1..boxcount).each do |boxno|
        counter = counter + 1; # global counter, used to index free mgmgt ip set
        inteam = inteam + 1 # in team counter to set ip
        name = "cdmcs-"+teamnumber.to_s+"-"+_name +"-"+boxno.to_s
        nic1 = MGMT + FREE[counter].to_s
        nic2 = MOLO  + (START + teamnumber*10 + inteam).to_s
        nic0 = MOLO  + (START + teamnumber*10 + 1).to_s # first box first ip used for cluster settings
        #puts nic1 +" "+nic2+" "+ name
        File.open('lastrun.txt','a').puts nic1 +" "+nic2+" "+ name
        config.vm.define name do |machine|
            machine.vm.hostname = name
            machine.vm.network 'private_network', ip: nic1
            #vmtools mess up ubuntu 14 network ;(
            machine.vm.provision "shell",
              inline: $fix_network, :args => "#{nic1} #{nic2} #{name} #{teamnumber} #{_name}"
            machine.vm.provision "shell",
                inline: $all, :args => "#{nic2}"
            scripts.each do |provision_script|
              machine.vm.provision "shell",
                inline: provision_script, :args => "#{nic2} #{name} #{teamnumber} #{inteam} #{nic0}"
            end
            machine.vm.box = 'vsphere'
            require '../vagrantkeys/vsphere.rb'
            include VSphereKeys
            machine.vm.provider :vsphere do |vsphere|
              vsphere.memory_mb = mem * 1024
              ...



```

## setting up node
```
# inline: provision_script, :args => "#{nic2} #{name} #{teamnumber} #{inteam} #{nic0}"

CLUSTER=moloch-$3
NAME=$2
IP=$1
UNICASTHOSTS=$5

echo "setting up elastic cluster: ${CLUSTER} node: ${NAME} bind: ${IP} unicast host: ${UNICASTHOSTS}"
INSTALL_DIR=/provision
ES=1.7.3

mkdir -p ${INSTALL_DIR}/elasticsearch
cd ${INSTALL_DIR}/elasticsearch
if [ ! -f "elasticsearch-${ES}.deb" ]; then
  echo "Downloading and installing elastic search"
  wget -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ES}.deb
  if [ ! -f "elasticsearch-${ES}.deb" ]; then
    echo "$(date) ${NAME} $0[$$]: {telegaf: {status:ERROR, msg: missing elasticsearch-${ES}.deb}"
    exit -1
  fi
  dpkg -i elasticsearch-${ES}.deb
  /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head
  echo "[elasticsearch]" >> /etc/opt/telegraf/telegraf.conf
  echo 'servers = ["http://'${IP}':9200"]' >> /etc/opt/telegraf/telegraf.conf
  echo "  local = true" >> /etc/opt/telegraf/telegraf.conf
  echo "  cluster_health = false" >> /etc/opt/telegraf/telegraf.conf
  service telegraf restart
else
  service elasticsearch stop
fi

echo "cluster.name: ${CLUSTER}" > /etc/elasticsearch/elasticsearch.yml
echo "node.name: ${NAME} " >> /etc/elasticsearch/elasticsearch.yml
echo "node.max_local_storage_nodes: 1 " >> /etc/elasticsearch/elasticsearch.yml
echo "index.number_of_replicas: 0 " >> /etc/elasticsearch/elasticsearch.yml
echo "index.fielddata.cache: node " >> /etc/elasticsearch/elasticsearch.yml
echo "indices.fielddata.cache.size: 40% " >> /etc/elasticsearch/elasticsearch.yml
echo "http.compression: true " >> /etc/elasticsearch/elasticsearch.yml
echo "script.disable_dynamic: true " >> /etc/elasticsearch/elasticsearch.yml
echo "bootstrap.mlockall: true " >> /etc/elasticsearch/elasticsearch.yml
echo "network.bind_host: ${IP}" >> /etc/elasticsearch/elasticsearch.yml
echo "network.publish_host: ${IP}" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: {$IP}" >> /etc/elasticsearch/elasticsearch.yml
echo "gateway.type: local" >> /etc/elasticsearch/elasticsearch.yml
echo "gateway.recover_after_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
echo "gateway.recover_after_time: 5m" >> /etc/elasticsearch/elasticsearch.yml
echo "gateway.expected_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.minimum_master_nodes: 1" >> /etc/elasticsearch/elasticsearch.yml
echo "discovery.zen.ping.multicast.enabled: false" >> /etc/elasticsearch/elasticsearch.yml
echo 'discovery.zen.ping.unicast.hosts: ["'${UNICASTHOSTS}'"]' >> /etc/elasticsearch/elasticsearch.yml

service elasticsearch start
```
