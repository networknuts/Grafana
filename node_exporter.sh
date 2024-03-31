#!/bin/bash

wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz
sudo cp node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin
sudo useradd --no-create-home --shell /bin/false node_exporter
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo cp node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
echo "Success!"
echo "Node Exporter uses Port 9100/TCP"
