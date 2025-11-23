#!/bin/bash

echo "[+] Installing essentials packages..."
sudo apt install fish wget jq
echo "[+] Setting fish shell as default..."
chsh -s $(which fish)
fish ./configure.fish

