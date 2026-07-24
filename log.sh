#!/bin/bash

#apt update
echo "Выполняется установка default-jdk"
#apt install -y default-jdk
echo "Установка default-jdk успешно выполнилась"
echo "Выполняется установка elasticsearch"
#dpkg -i /home/asur/elasticsearch_8.17.1_amd64-224190-db972d.deb
echo "Установка elasticsearch успешно выполнилась"
echo "Идет настройка параметров Java"
#cat > /etc/elasticsearch/jvm.options.d/jvm.options <<EOF
#-Xms1g
#-Xmx1g
#EOF
echo "Выполняется настройка конфигурационных файлов elasticsearch"
#cp -f /home/asur/repo_asur/log/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
#systemctl daemon-reload
#systemctl enable --now elasticsearch.service
#systemctl start elasticsearch.service
echo "Проверка работоспособности elasticsearch"
curl http://localhost:9200
echo "Выполняется установка kibana"
#dpkg -i /home/asur/kibana_8.17.1_amd64-224190-42bf22.deb
#systemctl daemon-reload
#systemctl enable --now kibana.service
#systemctl start kibana.service
echo "Установка kibana успешно выполнилась"
echo "Выполняется настройка конфигурационных файлов kibana"
#cp -f /home/asur/repo_asur/log/kibana.yml /etc/kibana/kibana.yml
#systemctl restart kibana.service
echo "Установка elasticsearch успешно выполнилась"
echo "Выполняется установка logstash"
#dpkg -i /home/asur/logstash_8.17.1_amd64-224190-40c12c.deb
#systemctl enable --now logstash.service
#systemctl start logstash.service
echo "Установка logstash успешно выполнилась"
#cp -f /home/asur/repo_asur/log/logstash.yml /etc/logstash/logstash.yml
echo "Выполняется настройка конфигурационных файлов logstash"
#systemctl restart logstash.service
echo "Скрипт выполнился успешно"
