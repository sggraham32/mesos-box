#!/bin/bash
#set -x #echo on

echo configure-worker...
#$1 expected to be an array of resources
#$2 expected to be an array of attributes for the worker node
#$3 expected to be a comma separated list of ip addresses (in zookeeper id order)
#$4 node ip

#follows https://open.mesosphere.com/getting-started/datacenter/install/
apt-get -y install mesos

# Disable zookeeper service
# sudo sh -c "echo manual > /etc/init/zookeeper.override"
service zookeeper stop
echo manual | tee /etc/init/zookeeper.override

# Disable mesos-master service
# sudo sh -c "echo manual > /etc/init/mesos-master.override"
service mesos-master stop
echo manual | tee /etc/init/mesos-master.override

echo $1 | tee /etc/mesos-slave/resources

echo $2 | tee /etc/mesos-slave/attributes

#Set /etc/mesos/zk to:
#     zk://1.1.1.1:2181,2.2.2.2:2181,3.3.3.3:2181/mesos
zk_str="zk://"

IFS=","
zk_ips=($3)

num_ips=${#zk_ips[@]}

unset IFS
for i in "${!zk_ips[@]}"
do
  zk_str=$zk_str"${zk_ips[$i]}"":2181"
  if (($i < $num_ips-1)); then
    zk_str+=,
  fi
done
zk_str=$zk_str"/mesos"

echo $zk_str | tee /etc/mesos/zk
#echo $zk_str | tee /etc/mesos-slave/master

#set node ip in /etc/mesos-slave/hostname
echo $4 | tee /etc/mesos-slave/hostname
echo $4 | tee /etc/mesos-slave/ip

#restart the mesos-slave service
service mesos-slave restart

