#!/usr/bin/env bash

echo "Manual install of code extensions"
# sleep 10

echo `whoami`
echo `pwd`
echo $PATH

export VSCODE_IPC_HOOK_CLI="$(ls /tmp/vscode-ipc-*.sock  | head -n 1)"
code_server_bin=$(ps -aux | grep "bin/code-server" | awk '{print $12}' | head -n 1)
code_bin=$(dirname "$code_server_bin")/remote-cli/code

echo $VSCODE_IPC_HOOK_CLI
echo $code_bin

echo "$code_bin --install-extension github.copilot"
$code_bin --install-extension github.copilot

# echo "Install and startup Tailscale"
curl -fsSL https://tailscale.com/install.sh | sh
sudo truncate -s 0 /etc/default/tailscaled
sudo tee -a /etc/default/tailscaled > /dev/null <<EOT
PORT="41641"
FLAGS="--tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055"
EOT
sudo cp ./tailscale/tailscale /etc/init.d/tailscale
sudo chmod a+x /etc/init.d/tailscale
sudo service tailscale start
# sudo tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 &

echo "Install Proxychains"
sudo apt-get install proxychains -y
sudo truncate -s 0 /etc/proxychains.conf
sudo tee -a /etc/proxychains.conf > /dev/null <<EOT
strict_chain
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5          127.0.0.1       1055
EOT

# echo "Install Github CLI"
# type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
# curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
# && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
# && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
# && sudo apt update \
# && sudo apt install gh -y


