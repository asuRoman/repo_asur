#!/bin/bash
apt update
apt install -y nginx
apt install -y apache2
cp --attributes-only /etc/apache2/ports.conf /home/asur/repo_asur/ports.conf && mv /home/asur/repo_asur/ports.conf /etc/apache2/ports.conf
apachectl -t
service apache2 start
cp --attributes-only /etc/nginx/sites-enabled/default /home/asur/repo_asur/default && mv /home/asur/repo_asur/default /etc/nginx/sites-enabled/default
service nginx reload
cp --attributes-only /etc/apache2/sites-enabled/000-default.conf /home/asur/repo_asur/000-default.conf && mv /home/asur/repo_asur/000-default.conf /etc/apache2/sites-enabled/000-default.conf
service apache2 reload
 
cp -r /var/www/html/ /var/www/html1 
cp -r /var/www/html/ /var/www/html2
cd
cp --attributes-only /var/www/html/index.html /home/asur/repo_asur/html/html/index.html && mv /home/asur/repo_asur/html/html/index.html /var/www/html/index.html

cp --attributes-only /var/www/html1/index.html /home/asur/repo_asur/html/html1/index.html && mv /home/asur/repo_asur/html/html1/index.html /var/www/html1/index.html

cp --attributes-only /var/www/html2/index.html /home/asur/repo_asur/html/html2/index.html && mv /home/asur/repo_asur/html/html2/index.html /var/www/html2/index.html

sudo service apache2 reload
apt install -y prometheus-node-exporter
dpkg -i /home/asur/filebeat_8.17.1_amd64-224190-a5f894.deb
cp --attributes-only /etc/filebeat/filebeat.yml /home/asur/repo_asur/filebeat.yml && mv /home/asur/repo_asur/filebeat.yml /etc/filebeat/filebeat.yml
sudo systemctl restart filebeat
