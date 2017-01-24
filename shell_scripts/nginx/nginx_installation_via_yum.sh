#!/bin/bash
#
# yum install nginx on CentOS6
#
#

sudo yum -y install wget

sudo wget -c https://raw.githubusercontent.com/octowhale/ansible_notebook/master/playbook/nginx_installation_centos6.8/files/epel.repo

sudo \cp -a epel.repo /etc/yum.repos.d/

sudo yum -y install nginx

sudo /etc/init.d/nginx start


