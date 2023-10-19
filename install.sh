#!/bin/bash

echo "Manual install of code extensions"
sleep 5

export VSCODE_IPC_HOOK_CLI="$(ls /tmp/vscode-ipc-*.sock  | head -n 1)"
code_server_bin=$(ps -aux | grep "bin/code-server" | awk '{print $12}' | head -n 1)
code_bin=$(dirname "$code_server_bin")/remote-cli/code

echo $VSCODE_IPC_HOOK_CLI
echo $code_bin

echo "$code_bin --install-extension github.copilot"
$code_bin --install-extension github.copilot
