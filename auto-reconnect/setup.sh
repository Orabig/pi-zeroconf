#!/bin/bash

echo "Installation du module autoreconnect"

sudo cp reconnect.pl /usr/bin/
sudo cp reconnect.service /lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable reconnect.service
sudo systemctl start reconnect.service
