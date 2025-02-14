#!/bin/bash

echo "🚀 Starting Raspberry Pi Kubernetes Setup 🚀"

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# Install required dependencies
echo "📦 Installing dependencies..."
sudo apt install -y curl wget apt-transport-https ca-certificates software-properties-common gnupg2 lsb-release conntrack

# 🔹 Fix potential dpkg issues before installing
echo "🛠 Fixing potential package issues..."
sudo dpkg --configure -a || true
sudo apt --fix-broken install -y || true

# 🔹 Install Docker (Fixes missing systemd service)
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
sudo systemctl daemon-reload
sudo systemctl enable --now docker

# Verify Docker installation
if ! command -v docker &> /dev/null; then
    echo "❌ Docker installation failed!"
    exit 1
fi

# 🔹 Install containerd
echo "📦 Installing containerd..."
sudo apt install -y containerd
sudo systemctl enable --now containerd

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

# Verify Kubectl installation
if ! command -v kubectl &> /dev/null; then
    echo "❌ Kubectl installation failed!"
    exit 1
fi

# 🔹 Install Helm (Fix for missing APT package)
echo "🎩 Installing Helm..."
if ! command -v helm &> /dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Verify Helm installation
if ! command -v helm &> /dev/null; then
    echo "❌ Helm installation failed!"
    exit 1
fi

# 🔹 Start Minikube (Fixes issues with Docker driver not running)
echo "🚀 Starting Minikube..."
minikube start --driver=docker || { echo "❌ Minikube failed to start!"; exit 1; }

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
