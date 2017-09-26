#!/bin/bash

kubectl delete -f connector/mongodb/
kubectl delete -f connector/mqtt/
kubectl delete -f mqtt/
kubectl delete -f mongo/
kubectl delete -f kafka/
kubectl delete -f zookeeper/