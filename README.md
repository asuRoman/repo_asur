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

1.7 Установить на веб сервер prometheus-node-exporter для сбора метрик

sudo apt install prometheus-node-exporter (настройка не требуется)

1.8 Установить на веб сервер filebeat для сбора логов из файла в репозитории filebeat_8.17.1_amd64-224190-a5f894.deb

Команда: sudo dpkg -i /home/asur/filebeat_8.17.1_amd64-224190-a5f894.deb
Скопировать конфигурационный файл filebeat.yml из репозитория в каталог /etc/filebeat/

в конце filebeat.inputs: добавить 
- type: filestream
  paths:
    - /var/log/nginx/*.log

  enabled: true
  exclude_files: ['.gz$']
  prospector.scanner.exclude_files: ['.gz$']

закоммитить все в Elasticsearch Output и добавить перед Logstash Output
output.logstash:
  hosts: ["localhost:5400"] - ip адрес сервера ELK

Рестартануть sudo systemctl restart filebeat

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

3. Настройка мониторинга Prometheus + Grafana

3.1 Установить Prometheus на хост, команда: sudo apt install prometheus

3.2 Установить Grafana на хост:

sudo apt install -y adduser libfontconfig1 musl - зависимости
wget https://dl.grafana.com/oss/release/grafana_10.0.3_amd64.deb
sudo dpkg -i grafana_10.0.3_amd64.deb (из репозитория)

Перезапустить службы
systemctl daemon-reload

Включить автозапуск grafana
sudo systemctl enable --now grafana-server.service

start grafana-server.service

3.3 Скопировать конфигурационный файл prometheus.yml из репозитория в каталог /etc/prometheus 

нужно заменить строки на наш ip адрес:
 - job_name: node
    static_configs:
      - targets: ['192.168.1.111:9100']

3.4 Настройка дашбордов в графана
Перейти по адресу 192.168.1.116:3000 и провести настрйоку по следующей инструкции:

Connectiios > Data source > Prometheus > Connection (http://localhost:9090)

Dashboards > New > Import > 1860 > Save > Import

4. Установка и настройка стека ELK для логирования

4.1 Установка Java на хост 

Команда: sudo apt install default-jdk

4.2 Установка elasticsearch на хост из файла в репозитории elasticsearch_8.17.1_amd64-224190-db972d.deb

sudo dpkg -i /home/asur/elasticsearch_8.17.1_amd64-224190-db972d.deb

4.3 Выставить лимит для java по потреблению оперативной памяти

sudo cat > /etc/elasticsearch/jvm.options.d/jvm.options

-Xms1g
-Xmx1g

4.4 Настраиваем конфиг elasticsearch (не безопасно, не работает с сертификатами)

Скопировать конфигурационный файл elasticsearch.yml из репозитория в каталог /etc/elasticsearch

Было:
xpack.security.enabled: true
xpack.security.enrollment.enabled: true
xpack.security.http.ssl:
enabled: true
xpack.security.transport.ssl:
enabled: true

Стало:
xpack.security.enabled: false
xpack.security.enrollment.enabled: false
xpack.security.http.ssl:
enabled: false
xpack.security.transport.ssl:
enabled: false

!!!Запускаем ELK

sudo systemctl daemon-reload
sudo systemctl enable --now elasticsearch.service
sudo systemctl start elasticsearch.service

Проверка curl http://localhost:9200

4.5 Установка kibana на хост из файла в репозитории kibana_8.17.1_amd64-224190-42bf22.deb

Команда:  sudo dpkg -i /home/asur/kibana_8.17.1_amd64-224190-42bf22.deb
Запускаем 
sudo systemctl daemon-reload
sudo systemctl enable --now kibana.service
sudo systemctl start kibana.service

Скопировать конфигурационный файл kibana.yml из репозитория в каталог /etc/kibana
Разкомитить:
server.port: 5601
и заменить server.host: "localhost" на server.host: "0.0.0.0" чтобы заходить со всех хостов

Перезапускаем сервис sudo systemctl restart kibana.service

4.6 Установка logstash  на хост из файла в репозитории logstash_8.17.1_amd64-224190-40c12c.deb

Запуск 

sudo systemctl enable --now logstash.service
sudo systemctl start logrotate.service

Скопировать конфигурационный файл logstash.yml из репозитория в каталог /etc/logstash

Добавить после # path.config: строчку path.config: /etc/logstash/conf.d отдельный файл для конфига который берется с NGINX

Задаем параметры cat > /etc/logstash/conf.d/logstash-nginx-es.conf для перерабатывания файла из исходника filebeat в формат logstash
input {
    beats {
        port => 5400
    }
}

filter {
 grok {
   match => [ "message" , "%{COMBINEDAPACHELOG}+%{GREEDYDATA:extra_fields}"]
   overwrite => [ "message" ]
 }
 mutate {
   convert => ["response", "integer"]
   convert => ["bytes", "integer"]
   convert => ["responsetime", "float"]
 }
 date {
   match => [ "timestamp" , "dd/MMM/YYYY:HH:mm:ss Z" ]
   remove_field => [ "timestamp" ]
 }
 useragent {
   source => "agent"
 }
}

output {
 elasticsearch {
   hosts => ["http://localhost:9200"]
   #cacert => '/etc/logstash/certs/http_ca.crt'
   #ssl => true
   index => "weblogs-%{+YYYY.MM.dd}"
   document_type => "nginx_logs"
 }
 stdout { codec => rubydebug }
}


Перезапустить logstash 
sudo systemctl restart logstash.service
