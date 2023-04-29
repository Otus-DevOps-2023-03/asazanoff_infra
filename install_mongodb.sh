#!/bin/bash
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt install apt-transport-https ca-certificates
sudo apt update
sudo apt upgrade
sudo apt install -y mongodb-org
sudo systemctl status mongod # after install
sudo systemctl start mongod
sudo systemctl status mongod # after start
sudo systemctl enable mongod
sudo systemctl status mongod # after enabling
