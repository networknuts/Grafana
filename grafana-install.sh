#!/bin/bash

apt-get install -y apt-transport-https
apt-get install -y software-properties-common wget
wget -q -O /usr/share/keyrings/grafana.key https://packages.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] \
              https://packages.grafana.com/enterprise/deb stable main" | sudo \
              tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install grafana-enterprise -y
systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server
