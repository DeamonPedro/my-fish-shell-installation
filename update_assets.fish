#!/usr/bin/fish

echo "Plugins detected:"
set plugins_detected ()
for installed_plugin in (fisher list)
    echo " - $installed_plugin"
    set plugins_detected $plugins_detected "\"$installed_plugin\""
end
set plugins_detected (string join  ',' $plugins_detected)
set tmp_json (mktemp)
jq ". + {fish_plugins: ["$plugins_detected"]}" assets_config.json > $tmp_json && mv $tmp_json assets_config.json

set assets_dirs (jq -r '.assets | keys[]' assets_config.json)
for dir in $assets_dirs
    mkdir -p $dir
    for file in (jq -r --arg dir "$dir" '.assets[$dir][]' assets_config.json)
        set from_path (realpath -m "$__fish_config_dir/$file")
        set to_path "$dir"/(basename "$file")
        echo "[+] Copying [$from_path] to [$to_path]..."
        cp $from_path $to_path
    end
end
