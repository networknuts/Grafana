#!/bin/bash

wget https://github.com/prometheus/pushgateway/releases/download/v0.8.0/pushgateway-0.8.0.linux-amd64.tar.gz
tar xvzf pushgateway-0.8.0.linux-amd64.tar.gz
cp pushgateway-0.8.0.linux-amd64/pushgateway /usr/bin/pushgateway
cp pushgateway.service /etc/systemd/system/pushgateway.service
systemctl daemon-reload
systemctl start pushgateway.service
systemctl enable pushgateway.service
firewall-cmd --permanent --add-port=9091/tcp
firewall-cmd --reload
