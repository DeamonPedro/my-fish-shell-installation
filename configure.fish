echo "[+] Installing fonts..."
sudo cp -r ./fonts/* "$HOME/.local/share/fonts/"

echo "[+] Installing bin..."
sudo cp -r ./prebuilt_bin/* /usr/local/bin/

curl -sL https://git.io/fisher | source
for plugin in (jq 'fish_plugins' assets_config.json)
    echo "[+] Installing plugin [$plugin]..."
    fisher install "$plugin" >/dev/null
end
for dir in (jq 'assets.$keys()' assets_config.json)
    mkdir -p $dir
    for file in (jq "assets.$dir" assets_config.json)
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
