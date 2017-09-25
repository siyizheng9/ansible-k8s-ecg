#!/bin/bash

# Note remember to replace ip address in  host list of kubernetes signing request

# This shell script should generate needed CA files and private keys
# and also mv file to the corret directories.

# get cluster machines' ip addresses

controller1="192.168.1.101"
worker1="192.168.1.102"
worker2="192.168.1.103"

mkdir ssl
cd ssl

echo 'creating CA configuration file'
touch ca-config.json
cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
EOF

echo 'creating CA certificate signing request'
cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "FI",
      "L": "Helsinki",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Espoo"
    }
  ]
}
EOF

# generate CA certificate and private key
echo 'generating CA certificate and private key'
cfssl gencert -initca ca-csr.json | cfssljson -bare ca 

# create admin certificate signing request
echo 'creating amdin certificate signing request'
cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "FI",
      "ST": "Espoo",
      "L": "Helsinki",
      "O": "system:masters",
      "OU": "Cluster"
    }
  ]
}
EOF

# generate admin certificate and private key
echo 'generating amdin certificate and privat key'
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json \
-profile=kubernetes admin-csr.json | cfssljson -bare admin


# create kube-proxy certificate signing request
echo 'ceating kub-proxy certificate signing request'
cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "FI",
      "L": "Helsinki",
      "O": "system:node-proxier",
      "OU": "Cluster",
      "ST": "Espoo"
    }
  ]
}
EOF

# generate kube-proxy client certificate and private key
echo 'generating kube-proxy client certificate and private key'
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes \
kube-proxy-csr.json | cfssljson -bare kube-proxy

# create kubernetes certificate signing request
# remember to add server's public ip address to host list
echo 'create kuberntes certificate signing request'
cat > kubernetes-csr.json <<EOF
{
    "CN": "kubernetes",
    "hosts": [
      "${controller1}",
      "${worker1}",
      "${worker2}",
      "10.32.0.1",
      "127.0.0.1",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "FI",
            "L": "Helsinki",
            "O": "Kubernetes",
            "OU": "Cluster",
            "ST": "Espoo"
        }
    ]
}
EOF

# generate kubernetes certificate and private key
echo 'generating kubernetes certificate and private key'
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json \
-profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes


echo 'generating kubelet certificate kyes'
#tune the NODE_FQDN for each workernode separately
for NODE_FQDN in 2 3; do
cat > kubelet-csr.json <<EOF
{
    "CN": "system:node:worker${NODE_FQDN}",
    "hosts": [
      "${controller1}",
      "${worker1}",
      "${worker2}",
      "10.32.0.1",
      "127.0.0.1",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local",
      "worker2",
      "worker3"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "FI",
            "L": "Helsinki",
            "O": "Kubernetes",
            "OU": "Cluster",
            "ST": "Espoo"
        }
    ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json \
-profile=kubernetes kubelet-csr.json | cfssljson -bare kubelet

mv kubelet.pem kubelet${NODE_FQDN}.pem
mv kubelet-key.pem kubelet-key${NODE_FQDN}.pem

done

