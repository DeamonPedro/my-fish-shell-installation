echo "[+] Installing fish plugins..."
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jorgebucaran/replay.fish
fisher install jorgebucaran/autopair.fish

echo "[+] Installing fonts..."
mkdir -p "$HOME/.local/share/fonts/Hack NF FC Ligatured"
cp ./fonts/HackNFFCLigatured-Regular.ttf "$HOME/.local/share/fonts/Hack NF FC Ligatured"

echo "[+] Installing assets..."
set assets_dirs (./bin/jfq '$keys()' assets_config.json)
for dir in $assets_dirs
    mkdir -p $dir
    for file in (./bin/jfq "$dir" assets_config.json)
        set from_path "$dir"/(basename "$file")
        set to_path (realpath -m "$__fish_config_dir/$file")
        echo "[+] Copying [$from_path] to [$to_path]..."
        mkdir -p (dirname (realpath -m $to_path))
        cp $from_path $to_path
    end
end

echo "[+] Coping variables..."
cp ./var/fish_variables $__fish_config_dir

echo "[+] Successfully Installed!"
