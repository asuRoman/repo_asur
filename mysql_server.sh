#!/bin/bash

#hostnamectl set-hostname mysql-master
#systemctl reboot
#apt update
echo "Выполняется установка mysql"
#apt install mysql-server-8.0
echo "Установка mysql успешно выполнилась"
#systemctl start mysql
echo "Выполняется настройка конфигурационных файлов mysql"
cp -f /home/asur/repo_asur/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
#mysql
echo "Выполняется создание пользователя для подключения с репликации"
#CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY '12131415';
# выдать права на работу с репликацией
echo "Выдаются права на работу с репликации"
#GRANT REPLICATION SLAVE ON *.* TO repl@'%';
#exit
