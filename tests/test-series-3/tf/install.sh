#!/bin/bash

sudo apt-get update 
sudo apt-get install vim git dtrx curl wget -y 
wget -qO- https://get.docker.com/ | sh
sudo docker pull davidporter/node-dynamodb-crud-app
sudo docker run -d -p 3000:3000 davidporter/node-dynamodb-crud-app 

sleep 5
# now insert some data to the webserver: 
for i in {1000..2000}
do
    curl localhost:3000/$i -X PUT -H "content-type: application/json"  -d '{"lookup":"123","data":"bar"}'
done
