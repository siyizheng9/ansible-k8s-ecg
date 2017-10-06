#!/bin/bash
# set -x

node1_ip="10.0.0.13"
node2_ip="10.0.0.14"
node3_ip="10.0.0.9"

node1=worker${node1_ip: -1}
node2=worker${node2_ip: -1}
node3=worker${node3_ip: -1}

sed -e "s/node1_ip/$node1_ip/g" main.yml.sed > main.yml
sed -i -e "s/node2_ip/$node2_ip/g" main.yml
sed -i -e "s/node3_ip/$node3_ip/g" main.yml

sed -i -e "s/node1/$node1/g" main.yml
sed -i -e "s/node2/$node2/g" main.yml
sed -i -e "s/node3/$node3/g" main.yml

