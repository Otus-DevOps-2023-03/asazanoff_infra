#!/bin/bash
yc compute instance create --name reddit-full --zone ru-central1-a --create-boot-disk name=disk1,size=10,image-name=reddit-full --public-ip
