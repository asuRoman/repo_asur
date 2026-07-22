# README

1. Установка и настройка NGINX и Apache

1.1 Установка NGINX, команда: sudo apt install nginx

1.2 Установка Apache, команда: sudo apt install apache2

1.3 Скопировать конфигурационный файл ports.conf из репозитория в каталог /etc/apache (/etc/apache2/ports.conf)

В данном файле меняется порт 80 на порт 8080 для Apache, чтобы NHINX и Apache жили на разных портах

Тестируем конфигурацию Apache (apachectl -t), если ошибок нет, то все ОК

Запускаем сервис (sudo service apache2 start)

1.4 Настройка reverse proxy

Скопировать конфигурационный файл default из репозитория в каталог /etc/nginx/sites-enabled/ (/etc/nginx/sites-enabled/default) (а именно надо заменить location) чтобы проксировать запросы на порт 8080 (Apache)

location / {
			#try_files $uri $uri/ =404;
			proxy_pass http://localhost:8080;
			proxy_set_header Host $host;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Real-IP $remote_addr;
		}

а также настройка балансировки между web должна быть в самом верху файла

upstream backend {
	server 127.0.0.1:8080 weight=2;
	server 127.0.0.1:8081;
	server 127.0.0.1:8082;
}

Перезапускаем конфиг (sudo service nginx reload)

1.5 Настройка балансировки Apache

Скопировать конфигурационный файл 000-default.conf из репозитория в каталог /etc/apache2/sites-enabled/ (/etc/apache2/sites-enabled/000-default.conf) чтобы настроить балансировку на порты 8080, 8081, 8082

Рестарт сервиса (sudo service apache2 reload)

1.6 Создаем директории для html страниц (html старницы будут копироваться из репозитория)

cd /var/www/
sudo cp -r html/ html1 
sudo cp -r html/ html2
Рестарт сервиса (sudo service apache2 reload)


2. Установка и настройка MySql сервера + replica MySql

На обеих хостовых машинах настроена сеть, заменены имена хостов на mysql-master - основной и replica - для репликации.

2.1 Установка MySql 
Команда: apt install mysql-server-8.0

2.2 Настройка конфигурационного файла
Скопировать конфигурационный файл mysqld.cnf из репозитория в каталог /etc/mysql/mysql.conf.d 
В нем меняется  bind-address на 0.0.0.0 чтобы мы могли подлкючаться с любых адресов, а также разкомититься server-id =1, чтобы мы считали этот сервер основным и после этого добавляем строчки:

gtid-mode=ON (включаем gtid-mode, для настройки replica)
enforce-gtid-consistency
log-replica-updates

После этого перезапустить службу (sudo service mysql restart)

2.3 
В MySQL создать пользователя repl для подключения с репликации
CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY '12131415';
и выдать права на работу с репл
GRANT REPLICATION SLAVE ON *.* TO repl@'%';

2.4 Настройка репликации
Скопировать конфигурационный файл mysqld.cnf из репозитория в каталог /etc/mysql/mysql.conf.d 
В нем меняется  bind-address на 0.0.0.0 чтобы мы могли подлкючаться с любых адресов, а также разкомититься server-id =1, чтобы мы считали этот сервер основным и после этого добавляем строчки:

relay-log = relay-log-server пишем изменения с основного сервера
read-only = ON только чтения от обычных юзеров
gtid-mode=ON
enforce-gtid-consistency
log-replica-updates

После этого перезапустить службу (sudo service mysql restart)

2.5 Запуск репликации с основного сервера

sudo mysql
STOP REPLICA;
CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.1.113', SOURCE_USER='repl', SOURCE_PASSWORD='12131415', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;
START REPLICA;
show replica status\G;

SOURCE_AUTO_POSITION = 1 - настройка вычитывает все неизвестные транзакции с основного сервера, все что он не видел нам надо получить
GET_SOURCE_PUBLIC_KEY = 1 - для подключения

2.6 Запуск скрипта бэкапа

Запустить файл backup.sh из репозитория

