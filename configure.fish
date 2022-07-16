echo "[+] Installing fish plugins..."
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jorgebucaran/replay.fish
fisher install jorgebucaran/autopair.fish
echo "[+] Installing fonts..."
mkdir -p "$HOME/.local/share/fonts/Hack NF FC Ligatured"
cp ./fonts/HackNFFCLigatured-Regular.ttf "$HOME/.local/share/fonts/Hack NF FC Ligatured"
echo "[+] Installing configs..."
set FISH_CONFIG "$HOME/.config/fish"
mkdir -p $FISH_CONFIG
mkdir -p "$FISH_CONFIG/conf.d/"
cp -r ./functions $FISH_CONFIG
cp -r ./config "$FISH_CONFIG/conf.d/"
cp ./var/fish_variables $FISH_CONFIG