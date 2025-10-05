#!/bin/bash
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 53317/udp
sudo ufw allow 53317/tcp
sudo ufw allow 22/tcp
sudo ufw allow in on docker0 to any port 53
sudo ufw-docker install
sudo ufw reload
