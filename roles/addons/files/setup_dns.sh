#!/bin/bash

export DNS_DOMAIN="cluster.local"
export DNS_SERVER_IP="10.32.0.10"

URL=https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/addons/dns
curl -sSL -o - $URL/kubedns-controller.yaml.sed \
  | sed -e "s/\\\$DNS_DOMAIN/${DNS_DOMAIN}/g" > kubedns-controller.yaml
curl -sSL -o - $URL/kubedns-svc.yaml.sed \
  | sed -e "s/\\\$DNS_SERVER_IP/${DNS_SERVER_IP}/g" > kubedns-svc.yaml
curl -sSLO $URL/kubedns-sa.yaml
curl -sSLO $URL/kubedns-cm.yaml

for i in kubedns-{sa,cm,controller,svc}.yaml; do
  kubectl --namespace=kube-system apply -f $i;
done

