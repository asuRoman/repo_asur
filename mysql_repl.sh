#!/bin/bash

hostnamectl set-hostname replica
systemctl reboot
apt update
apt install mysql-server-8.0
systemctl start mysql
cp -f /home/asur/repo_asur/repl/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
cp -f /home/asur/repo_asur/repl/.my.cnf /home/asur
service mysql restart
sudo mysql
STOP REPLICA;
CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.1.113', SOURCE_USER='repl', SOURCE_PASSWORD='12131415', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;
START REPLICA;
show replica status\G;
