#!/bin/bash

mkdir bootstrap
cd bootstrap

# controller1='192.168.1.101'

# start generating TLS Bootstrap Token
echo 'Creating Token auth file'

export BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
cat > token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF

# Create the bootstrap kubeconfig file
echo 'Create the bootstrap kubeconfig file'
kubectl config set-cluster kubernetes \
  --certificate-authority='../ssl/ca.pem' \
  --embed-certs=true \
  --server=https://{{ CONTROLLER }}:6443 \
  --kubeconfig=bootstrap.kubeconfig

kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=bootstrap.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=bootstrap.kubeconfig

kubectl config use-context default --kubeconfig=bootstrap.kubeconfig

# Create the kube-proxy kubeconfig
echo 'Create the kube-proxy kubeconfig'

kubectl config set-cluster kubernetes\
  --certificate-authority='../ssl/ca.pem' \
  --embed-certs=true \
  --server=https://{{ CONTROLLER }}:6443 \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials kube-proxy \
  --client-certificate='../ssl/kube-proxy.pem' \
  --client-key='../ssl/kube-proxy-key.pem' \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
