#!/bin/bash

#apt install prometheus
#apt install -y adduser libfontconfig1 musl
#wget https://dl.grafana.com/oss/release/grafana_10.0.3_amd64.deb
#dpkg -i grafana_10.0.3_amd64.deb
cp -f /home/asur/repo_asur/mon/prometheus.yml /etc/prometheus/prometheus.yml
#systemctl daemon-reload
#systemctl enable --now grafana-server.service
systemctl restart grafana-server.service
systemctl restart prometheus
