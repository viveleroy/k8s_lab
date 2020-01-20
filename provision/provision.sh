#!/bin/bash
set -x

# Disable swap until next reboot
sudo swapoff -a

# Update the local node
sudo apt-get update && sudo apt-get upgrade -y
# Install Docker
sudo apt-get install -y docker.io
# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl enable docker.service
systemctl restart docker.service
# Install kubeadm and kubectl
# sudo sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-bionic main' >> /etc/apt/sources.list.d/kubernetes.list"
sudo sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update
sudo apt-get install -y kubeadm=1.16.1-00 kubelet=1.16.1-00 kubectl=1.16.1-00
sudo apt-mark hold kubelet kubeadm kubectl
