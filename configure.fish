echo "[+] Installing fish plugins..."
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jorgebucaran/replay.fish
fisher install jorgebucaran/autopair.fish
echo "[+] Installing fonts..."
mkdir -p "$HOME/.local/share/fonts/Hack NF FC Ligatured"
cp ./fonts/HackNFFCLigatured-Regular.ttf "$HOME/.local/share/fonts/Hack NF FC Ligatured"
echo "[+] Installing configs..."
mkdir -p $__fish_config_dir
mkdir -p "$__fish_config_dir/conf.d/"
cp -r ./functions $__fish_config_dir
cp -r ./config "$__fish_config_dir/conf.d/"
cp ./var/fish_variables $__fish_config_dir