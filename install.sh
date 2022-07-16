#!/bin/bash

echo "[+] Installing fish shell..."
sudo apt install fish
echo "[+] Setting fish shell as default..."
chsh -s $(which fish)
fish ./configure.fish

