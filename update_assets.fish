#!/usr/bin/fish

set assets_dirs (./bin/jfq '$keys()' assets_config.json)
for dir in $assets_dirs
    mkdir -p $dir
    for file in (./bin/jfq "$dir" assets_config.json)
        set from_path (realpath -m "$__fish_config_dir/$file")
        set to_path "$dir"/(basename "$file")
        echo "[+] Copying [$from_path] to [$to_path]..."
        cp $from_path $to_path
    end
end
