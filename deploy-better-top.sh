#!/bin/bash

sudo cp better-top.sh /usr/bin/better-top
sudo cp better-top.service /etc/systemd/system/better-top.service
sudo cp better-top.timer /etc/systemd/system/better-top.timer
sudo systemctl daemon-reload
sudo systemctl start better-top.service
sudo systemctl enable better-top.service
sudo systemctl start better-top.timer
sudo systemctl enable better-top.timer
