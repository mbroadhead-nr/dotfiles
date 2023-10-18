#!/bin/bash

# Find the path to the code executable
VSCODE_EXECUTABLE=$(which code)

# Check if the code executable is found
if [ -z "$VSCODE_EXECUTABLE" ]; then
  echo "Visual Studio Code executable not found."
  exit 1
fi

# Install GitHub Copilot
$VSCODE_EXECUTABLE --install-extension github.copilot
