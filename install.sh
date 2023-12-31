#!/usr/bin/env bash

echo `whoami`
echo `pwd`
echo $PATH
echo `git remote get-url origin`

# echo "Manual install of code extensions"
# # sleep 10

# export VSCODE_IPC_HOOK_CLI="$(ls /tmp/vscode-ipc-*.sock  | head -n 1)"
# code_server_bin=$(ps -aux | grep "bin/code-server" | awk '{print $12}' | head -n 1)
# code_bin=$(dirname "$code_server_bin")/remote-cli/code

# echo $VSCODE_IPC_HOOK_CLI
# echo $code_bin

# echo "$code_bin --install-extension github.copilot"
# $code_bin --install-extension github.copilot


echo "Install and startup Tailscale"
curl -fsSL https://tailscale.com/install.sh | sh
sudo cp -f ./tailscale/tailscale /etc/init.d/tailscale
sudo chmod a+x /etc/init.d/tailscale
sudo service tailscale start
# sudo tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 &

echo "Install Proxychains"
sudo apt-get install proxychains -y
sudo cp -f ./tailscale/proxychains.conf /etc/proxychains.conf

# echo "Install Github CLI"
# type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
# curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
# && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
# && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
# && sudo apt update \
# && sudo apt install gh -y


