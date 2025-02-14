#!/bin/bash

echo "🚀 Starting Raspberry Pi Kubernetes Setup 🚀"

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# Install required dependencies
echo "📦 Installing dependencies..."
sudo apt install -y curl wget apt-transport-https ca-certificates software-properties-common gnupg2 lsb-release

# 🔹 Install Docker
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

# 🔹 Install containerd
echo "📦 Installing containerd..."
sudo apt install -y containerd
sudo systemctl enable containerd
sudo systemctl start containerd

# 🔹 Install Minikube
echo "🚀 Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/local/bin/minikube
rm minikube-linux-arm64

# 🔹 Install Kubectl
echo "📦 Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# 🔹 Install Helm
echo "🎩 Installing Helm..."
curl https://baltocdn.com/helm/signing.asc | sudo tee /etc/apt/keyrings/helm.asc > /dev/null
sudo apt install -y helm

# 🔹 Start Minikube
echo "🚀 Starting Minikube..."
minikube start --driver=docker

# 🔹 Enable Ingress in Minikube
echo "🌐 Enabling Ingress..."
minikube addons enable ingress

# 🔍 Run system checks
echo "🔍 Running system checks..."
echo "✅ Docker Version: $(docker --version)"
echo "✅ Minikube Status:"
minikube status
echo "✅ Kubernetes Nodes:"
kubectl get nodes
echo "✅ Helm Version: $(helm version --short)"

echo "🎉 Setup Complete! Your Raspberry Pi is ready for Kubernetes!"
