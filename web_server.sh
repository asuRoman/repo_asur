#!/bin/bash

#apt update
echo "Выполняется установка NGINX"
#apt install -y nginx
echo "Установка NGINX успешно выполнилась"
echo "Выполняется установка Apache"
#apt install -y apache2
echo "Установка Apache успешно выполнилась"
echo "Выполняется настройка конфигурационных файлов Apache"
cp -f /home/asur/repo_asur/web/ports.conf /etc/apache2/ports.conf
#apachectl -t
#service apache2 start
echo "Выполняется настройка конфигурационных файлов Nginx"
cp -f /home/asur/repo_asur/web/default /etc/nginx/sites-enabled/default
#service nginx reload
cp -f /home/asur/repo_asur/web/000-default.conf /etc/apache2/sites-enabled/000-default.conf
#service apache2 reload
echo "Идет создание каталогов для для html страниц"
cp -r /var/www/html/ /var/www/html1
cp -r /var/www/html/ /var/www/html2
echo "Создание html страниц"
cp -f /home/asur/repo_asur/web/site_a/index.html /var/www/html/index.html

cp -f /home/asur/repo_asur/web/site_b/index.html /var/www/html1/index.html

cp -f /home/asur/repo_asur/web/site_c/index.html /var/www/html2/index.html

#service apache2 reload
echo "Выполняется установка prometheus-node-exporter"
#apt install -y prometheus-node-exporter
echo "Установка prometheus-node-exporter успешно выполнилась"
echo "Выполняется установка filebeat"
#dpkg -i /home/asur/filebeat_8.17.1_amd64-224190-a5f894.deb
echo "Установка filebeat успешно выполнилась"
echo "Выполняется настройка конфигурационных файлов filebeat"
cp -f /home/asur/repo_asur/web/filebeat.yml /etc/filebeat/filebeat.yml
systemctl restart nginx.service
systemctl restart apache2.service
systemctl restart filebeat
