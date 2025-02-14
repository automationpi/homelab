echo "📊 Installing k9s..."
ARCH=$(dpkg --print-architecture)
if [[ "$ARCH" == "arm64" ]]; then
  K9S_ARCH="arm64"
elif [[ "$ARCH" == "armhf" ]]; then
  K9S_ARCH="arm"
else
  K9S_ARCH="amd64"
fi

K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep "tag_name" | cut -d '"' -f 4)
wget https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${K9S_ARCH}.tar.gz

tar -xzf k9s_Linux_${K9S_ARCH}.tar.gz
chmod +x k9s
sudo mv k9s /usr/local/bin/
rm k9s_Linux_${K9S_ARCH}.tar.gz
