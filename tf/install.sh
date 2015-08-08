#!/bin/bash

sudo apt-get update 
sudo apt-get install vim git dtrx curl wget -y 
wget -qO- https://get.docker.com/ | sh
sudo docker pull davidporter/node-dynamodb-crud-app
sudo docker run -d -p 3000:3000 davidporter/node-dynamodb-crud-app 
