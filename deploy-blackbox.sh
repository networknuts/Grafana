#!/bin/bash

wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-amd64.tar.gz
tar -xvf blackbox_exporter-0.24.0.linux-amd64.tar.gz
sudo useradd -rs /bin/false blackbox
sudo cp blackbox_exporter-0.24.0.linux-amd64/blackbox_exporter /usr/bin/blackbox_exporter
sudo chmod 777 /usr/bin/blackbox_exporter
sudo cp blackbox_exporter-0.24.0.linux-amd64/blackbox.yml /usr/bin/blackbox.yml
sudo chmod 444 /usr/bin/blackbox.yml
sudo cp blackbox.service /etc/systemd/system/blackbox.service
sudo systemctl daemon-reload
sudo systemctl start blackbox
sudo systemctl enable blackbox
echo "Success!"
echo "Blacbkox uses port 9115/TCP"
echo "Refer to prometheus.blackbox.yml for reference."
