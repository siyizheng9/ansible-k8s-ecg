#!/bin/bash

sudo etcdctl \
  --ca-file=/etc/etcd/ca.pem \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  get /coreos.com/network/config

result=$?

if [[ result -ne 0 ]]; then
sudo etcdctl \
  --ca-file=/etc/etcd/ca.pem \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  set /coreos.com/network/config '{ "Network": "10.200.0.0/16", "Backend": {"Type": "vxlan"}}'
fi
 
