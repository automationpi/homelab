#!/bin/bash

echo "🚀 Cleaning up Minikube & Kubernetes from Raspberry Pi..."

# Stop and delete Minikube
echo "🛑 Stopping Minikube..."
minikube stop
minikube delete

# Remove Minikube binary
echo "🗑️ Removing Minikube..."
sudo rm -rf /usr/local/bin/minikube ~/.minikube /etc/kubernetes /var/lib/minikube /var/lib/kubelet

# Remove Kubernetes components
echo "🗑️ Removing Kubernetes components (kubeadm, kubelet, kubectl)..."
sudo apt-get purge -y kubeadm kubectl kubelet kubernetes-cni
sudo apt-get autoremove -y
sudo rm -rf ~/.kube /etc/kubernetes /var/lib/kubelet /var/lib/etcd /var/lib/cni

# Remove Docker & Containerd
echo "🗑️ Removing Docker & Containerd..."
sudo apt-get purge -y docker.io containerd
sudo apt-get autoremove -y
sudo rm -rf /var/lib/docker /etc/docker
sudo rm -rf /var/lib/containerd /etc/containerd
sudo rm -rf /usr/bin/docker /usr/bin/containerd
sudo groupdel docker

# Reset iptables and networking
echo "🔄 Resetting iptables and networking..."
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X

# Reload system daemon
echo "🔄 Reloading system daemon..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "✅ Cleanup completed. Raspberry Pi is now free of Kubernetes & Minikube."
