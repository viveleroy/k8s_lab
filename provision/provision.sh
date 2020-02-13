#!/bin/bash
set -x

# Kubernetes package version to install
K8S_VERSION=1.16.1-00

# Disable swap until next reboot
sudo swapoff -a

# Disable swap permanently
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Update the local node
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
# Install Docker
sudo apt-get install -y docker.io

# Setup Docker daemon
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
sudo sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get update
sudo apt-get install -y kubeadm=$K8S_VERSION kubelet=$K8S_VERSION kubectl=$K8S_VERSION
sudo apt-mark hold kubelet kubeadm kubectl

# Bugfix for: 
# kubectl exec return error: unable to upgrade connection: pod does not exist
# https://github.com/kubernetes/kubernetes/issues/63702
KUBELET_CONF=/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
VAGRANT_IP=$(hostname -I | tr ' ' '\n'  | grep 192.168.33.2)
NODE_IP_ENV=Environment=\"KUBELET_EXTRA_ARGS=--node-ip=$VAGRANT_IP\"
if ! grep $NODE_IP_ENV $KUBELET_CONF; then
  PATTERN="EnvironmentFile\=\-\/etc\/default\/kubelet"
  sudo sed -i "/$PATTERN/ a $NODE_IP_ENV" $KUBELET_CONF
  sudo systemctl daemon-reload
  sudo systemctl restart kubelet
else
  echo "Node IP already configured"
fi
