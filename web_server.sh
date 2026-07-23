#!/bin/bash

#apt update
#apt install -y nginx
#apt install -y apache2
cp -f /home/asur/repo_asur/html/ports.conf /etc/apache2/ports.conf
#apachectl -t
#service apache2 start
cp -f /home/asur/repo_asur/html/default /etc/nginx/sites-enabled/default
#service nginx reload
cp -f /home/asur/repo_asur/html/000-default.conf /etc/apache2/sites-enabled/000-default.conf
#service apache2 reload

cp -r /var/www/html/ /var/www/html1
cp -r /var/www/html/ /var/www/html2

cp -f /home/asur/repo_asur/html/html/index.html /var/www/html/index.html

cp -f /home/asur/repo_asur/html/site/index.html /var/www/html1/index.html

cp -f /home/asur/repo_asur/html/siteb/index.html /var/www/html2/index.html

#service apache2 reload
#apt install -y prometheus-node-exporter
#dpkg -i /home/asur/filebeat_8.17.1_amd64-224190-a5f894.deb
cp -f /home/asur/repo_asur/nginx/filebeat.yml /etc/filebeat/filebeat.yml
systemctl restart nginx.service
systemctl restart apache2.service
systemctl restart filebeat
