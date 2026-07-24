#!/bin/bash

#apt update
apt install -y default-jdk
dpkg -i /home/asur/elasticsearch_8.17.1_amd64-224190-db972d.deb
cat > /etc/elasticsearch/jvm.options.d/jvm.options <<EOF
-Xms1g
-Xmx1g
EOF
cp -f /home/asur/repo_asur/log/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
systemctl daemon-reload
systemctl enable --now elasticsearch.service
systemctl start elasticsearch.service
curl http://localhost:9200
dpkg -i /home/asur/kibana_8.17.1_amd64-224190-42bf22.deb
systemctl daemon-reload
systemctl enable --now kibana.service
systemctl start kibana.service
cp -f /home/asur/repo_asur/log/kibana.yml /etc/kibana/kibana.yml
systemctl restart kibana.service
dpkg -i /home/asur/logstash_8.17.1_amd64-224190-40c12c.deb
systemctl enable --now logstash.service
systemctl start logstash.service
cp -f /home/asur/repo_asur/log/logstash.yml /etc/logstash/logstash.yml
systemctl restart logstash.service
