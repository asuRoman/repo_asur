#!/bin/bash

hostnamectl set-hostname mysql-master
systemctl reboot
apt update
apt install mysql-server-8.0
systemctl start mysql
cp -f /home/asur/repo_asur/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl start mysql
sudo mysql
CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY '12131415';
# выдать права на работу с репликацией
GRANT REPLICATION SLAVE ON *.* TO repl@'%';
exit