#!/bin/bash

kubectl apply -f zookeeper/

kubectl apply -f kafka/

kubectl apply -f mqtt/
kubectl apply -f mongo/

kubectl apply -f connector/mongodb/
kubectl apply -f connector/mqtt/