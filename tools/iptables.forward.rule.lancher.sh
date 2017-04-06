#!/bin/bash
#
# author: tangxin@haowan123.com
# date: 2017-03-10
# filename: iptables.forward.rule.lancher.sh
# version: 01
#

# 端口转发配置脚本
# iptables.forward.rule.lancher.sh [only|all]
#   only: 只允许 allow_ipaddrs 访问转发端口
#   all:  允许所有来源访问转发端口

target_ipaddr=10.10.10.10
target_port=8888

local_ipaddr=10.11.11.11
local_port=3001

[ -z $target_ipaddr ] && exit 
[ -z $local_port ] && exit 

allow_ipaddrs="111.111.111.111/32 10.11.0.0/16"

function allow_ipaddrs_list()
{ 
    for allow_ip in $allow_ipaddrs
    do
    {
        iptables -I INPUT -s $allow_ip -p tcp -m state --state NEW -m tcp --dport $local_port -j ACCEPT 
    }
    done
}

function forward_rules()
{
    iptables -A FORWARD -d ${target_ipaddr} -i eth0 -p tcp -m tcp --dport ${local_port} -j ACCEPT 
    iptables -A FORWARD -s ${target_ipaddr} -o eth0 -p tcp -m tcp --sport ${local_port} -j ACCEPT 
    iptables -t nat -A PREROUTING -d ${local_ipaddr} -i eth0 -p tcp -m tcp --dport ${local_port} -j DNAT --to-destination ${target_ipaddr}:${target_port} 
    iptables -t nat -A POSTROUTING -d ${target_ipaddr} -o eth0 -p tcp -m tcp --dport ${target_port} -j SNAT --to-source ${local_ipaddr} 
}


case $1 in 
only)
    allow_ipaddrs ;;
all)
    iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport $local_port -j ACCEPT
    ;;
esac

forward_rules
/etc/init.d/iptables save

