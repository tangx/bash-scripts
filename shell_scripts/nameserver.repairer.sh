#!/bin/bash
#
# mailto: uyinn@live.com
#
# 目的: 发现网络正常，但是不能解析域名时。
#       测试新的DNS服务器并更换

#
# 2015-09-17
#  + 实现需求功能
#


RESOLV_CONF=/etc/resolv.conf 
DNS_LIST="
8.8.8.8
205.171.3.65
198.41.0.4
205.171.2.65
114.114.114.114
183.60.52.90
66.33.206.206
192.5.5.241
192.203.230.10
165.87.13.129
"

# 检测nslookup是否存在
which nslookup || yum -y install bind-utils ;
# 检测网络通不通
# ping -q -c 1 8.8.8.8 || { echo "network error "; exit 1 ; }
ping -c 3 180.97.33.107 > /dev/null 2>&1 || { echo "network error "; exit 1 ; }

# 检测DNS是否可用
ping -c 3 www.baidu.com > /dev/null 2>&1 && exit 1;

while read dns_ipaddr
do
{
  [ -z "$dns_ipaddr" ] && continue # 跳过空行
  echo $dns_ipaddr 
  
  # 判断DNS 是否可用,不可用则
  nslookup google.com $dns_ipaddr > /dev/null 2>&1 && {
    cp -a $RESOLV_CONF $RESOLV_CONF.ori_$(date +%s)
    echo "nameserver $dns_ipaddr" > $RESOLV_CONF
    exit 
  } # || {
    # echo "next"
  # }
  
} 
done <<< "$DNS_LIST"

