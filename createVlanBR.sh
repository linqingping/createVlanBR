#!/bin/bash
net_name=$1
bridge_name=$2
#判断网卡配置文件是否存在备份
if [ ! -f "/etc/sysconfig/network-scripts/ifcfg-${net_name}.bak" ];then
   mv /etc/sysconfig/network-scripts/ifcfg-${net_name}{,.bak}
fi
#配置网卡信息
echo "DEVICE=${net_name}
ONBOOT=yes
BOOTPROTO=static">>/etc/sysconfig/network-scripts/ifcfg-${net_name}
#网卡创建vlan，并创建相应的网桥
#循环遍历vlan参数
for ((i=3;i<=$#;i++));
  do
    j=${!i}
    vconfig add ${net_name} $j
    #删除网卡ip link del eth0.10
    echo "VLAN=yes
TYPE=vlan
PHYSDEV=${net_name}
VLAN_ID=$j
NAME=${net_name}.$j
ONBOOT=yes
ZONE=trusted
DEVICE=${net_name}.$j
BRIDGE=${bridge_name}-$j">>/etc/sysconfig/network-scripts/ifcfg-${net_name}.$j
    brctl addbr ${bridge_name}-$j
    #删除网桥brctl delbr 'Bridge_name'
    echo "TYPE=bridge
BOOTPROTO=static
NAME=${bridge_name}-$j
DEVICE=${bridge_name}-$j
ONBOOT=yes">>/etc/sysconfig/network-scripts/ifcfg-${bridge_name}-$j
    brctl addif ${bridge_name}-$j ${net_name}.$j
    #解除绑定brctl delif bridge_name net_name
  done
