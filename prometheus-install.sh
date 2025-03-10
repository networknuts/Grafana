#!/bin/bash
# Installing packages
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
# Creating users for service
sudo useradd --no-create-home --shell /bin/false prome
# Creating prometheus directories
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
# Downloading and extracting files
wget https://github.com/prometheus/prometheus/releases/download/v3.2.1/prometheus-3.2.1.linux-amd64.tar.gz
tar -xvf prometheus-3.2.1.linux-amd64.tar.gz
# Copying files to respective locations and changing permissions
sudo cp prometheus-3.2.1.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-3.2.1.linux-amd64/promtool /usr/local/bin/
sudo chown prome:prome /usr/local/bin/prometheus
sudo chown prome:prome /usr/local/bin/promtool
sudo cp -r prometheus-3.2.1.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-3.2.1.linux-amd64/console_libraries /etc/prometheus
sudo chown -R prome:prome /etc/prometheus/consoles
sudo chown -R prome:prome /etc/prometheus/console_libraries
sudo chown -R prome:prome /var/lib/prometheus/
sudo cp prometheus.yml /etc/prometheus/prometheus.yml
sudo cp prometheus.service /etc/systemd/system/prometheus.service
# Perform service reloads and starts
sudo systemctl daemon-reload
sudo systemctl start prometheus.service
sudo systemctl enable prometheus.service
echo "prometheus uses port 9090"
