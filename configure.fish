echo "[+] Installing fonts..."
mkdir -p "$HOME/.local/share/fonts/Hack NF FC Ligatured"
cp ./fonts/HackNFFCLigatured-Regular.ttf "$HOME/.local/share/fonts/Hack NF FC Ligatured"

curl -sL https://git.io/fisher | source
for plugin in (./bin/jfq 'plugins' assets_config.json)
    echo "[+] Installing plugin [$plugin]..."
    fisher install "$plugin" >/dev/null
end
for dir in (./bin/jfq 'assets.$keys()' assets_config.json)
    mkdir -p $dir
    for file in (./bin/jfq "assets.$dir" assets_config.json)
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
