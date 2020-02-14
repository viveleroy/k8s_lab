#!/bin/bash
K9S_VERSION=0.14.1
set -x

sudo kubeadm init --apiserver-advertise-address 192.168.33.20 --kubernetes-version 1.16.1 --pod-network-cidr 172.16.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# Download Calico plugin and RBAC YAML files and apply
curl -sSL https://tinyurl.com/yb4xturm -o rbac-kdd.yaml
curl -sSL https://tinyurl.com/y2vqsobb -o calico.yaml

# Update POD CIDR for Calico
sed -i 's/192.168.0.0\/16/172.16.0.0\/16/' calico.yaml 

kubectl apply -f rbac-kdd.yaml
kubectl apply -f calico.yaml
kubectl get node
# Ensure using latest bash-completion
sudo apt install bash-completion -y -f
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
curl -sSL https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz -o k9s.tar.gz
tar -xzf k9s.tar.gz
sudo mv k9s /usr/local/bin/
rm k9s.tar.gz