#!/bin/bash
sudo mkdir -m 777 /var/otus-dz
cd /var/otus-dz
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
