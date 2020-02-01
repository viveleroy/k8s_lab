#!/bin/bash
set -x
sudo kubeadm init --apiserver-advertise-address 192.168.33.20 --kubernetes-version 1.16.1 --pod-network-cidr 192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# Download Calico plugin and RBAC YAML files and apply
curl -sSL https://tinyurl.com/yb4xturm -o rbac-kdd.yaml
curl -sSL https://tinyurl.com/y2vqsobb -o calico.yaml
kubectl apply -f rbac-kdd.yaml
kubectl apply -f calico.yaml
kubectl get node
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
wget https://github.com/derailed/k9s/releases/download/v0.13.0/k9s_0.13.0_Linux_x86_64.tar.gz
tar -xzf k9s_0.13.0_Linux_x86_64.tar.gz
sudo mv k9s /usr/local/bin/