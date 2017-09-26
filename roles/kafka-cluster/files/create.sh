#!/bin/bash
# set -x

check_readiness(){
while true
do
    DESIRED=$(kubectl -n kafka get statefulsets/$1|tail -1|awk '{print $2}')
    CURRENT=$(kubectl -n kafka get statefulsets/$1|tail -1|awk '{print $3}')

    if [[ $DESIRED -ne $CURRENT ]]; then
        echo "desired:$DESIRED, current:$CURRENT"
        echo "sleep 10 sec"
        sleep 10
        echo -e "\e[0K\r"
        echo -en "\e[3A"
        echo -en "\e[0K\r"
    else
        break
    fi
done
}

kubectl apply -f zookeeper/

check_readiness zoo 

kubectl apply -f kafka/

check_readiness kafka

kubectl -n kafka exec kafka-0 -- bin/kafka-topics.sh --create --zookeeper zookeeper.kafka --replication-factor 1 --partitions 1 --topic mqtt-test

kubectl apply -f mqtt/
kubectl apply -f mongo/

kubectl apply -f connector/mongodb/
kubectl apply -f connector/mqtt/

# kubectl -n kafka exec kafka-0 -- bin/kafka-topics.sh --list --zookeeper zookeeper.kafka