#!/bin/bash

#hostnamectl set-hostname replica
#systemctl reboot
#apt update
echo "Выполняется установка mysql"
#apt install mysql-server-8.0
echo "Установка mysql успешно выполнилась"
#systemctl start mysql
echo "Выполняется настройка конфигурационных файлов mysql"
cp -f /home/asur/repo_asur/repl/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
echo "Создается файл с авторизационными данными для создания бэкапа"
cp -f /home/asur/repo_asur/repl/.my.cnf /home/asur
systemctl restart mysql
#mysql
#STOP REPLICA;
echo "Выполняется запуск репликации"
#CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.1.113', SOURCE_USER='repl', SOURCE_PASSWORD='12131415', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;
#START REPLICA;
echo "Вывод состояния репликации"
show replica status\G;
