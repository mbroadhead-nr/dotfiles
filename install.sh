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
sudo tee -a /etc/init.d/tailscale > /dev/null <<EOT
#!/bin/sh
# Copyright (c) Tailscale Inc & AUTHORS
# SPDX-License-Identifier: BSD-3-Clause

### BEGIN INIT INFO
# Provides:             tailscaled
# Required-Start:
# Required-Stop:
# Default-Start:
# Default-Stop:
# Short-Description:    Tailscale Mesh Wireguard VPN
### END INIT INFO

set -e

# /etc/init.d/tailscale: start and stop the Tailscale VPN service

test -x /usr/sbin/tailscaled || exit 0

umask 022

. /lib/lsb/init-functions

# Are we running from init?
run_by_init() {
    ([ "$previous" ] && [ "$runlevel" ]) || [ "$runlevel" = S ]
}

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

case "$1" in
  start)
        log_daemon_msg "Starting Tailscale VPN" "tailscaled" || true
        if start-stop-daemon --start --oknodo --name tailscaled -m --pidfile /run/tailscaled.pid --background \
                --exec /usr/sbin/tailscaled -- \
                --state=/var/lib/tailscale/tailscaled.state \
                --socket=/run/tailscale/tailscaled.sock \
                --port 41641;
        then
            log_end_msg 0 || true
        else
            log_end_msg 1 || true
        fi
        ;;
  stop)
        log_daemon_msg "Stopping Tailscale VPN" "tailscaled" || true
        if start-stop-daemon --stop --remove-pidfile --pidfile /run/tailscaled.pid --exec /usr/sbin/tailscaled; then
            log_end_msg 0 || true
        else
            log_end_msg 1 || true
        fi
        ;;

  status)
        status_of_proc -p /run/tailscaled.pid /usr/sbin/tailscaled tailscaled && exit 0 || exit $?
        ;;

  *)
        log_action_msg "Usage: /etc/init.d/tailscaled {start|stop|status}" || true
        exit 1
esac

exit 0
EOT
sudo system tailscale start
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


