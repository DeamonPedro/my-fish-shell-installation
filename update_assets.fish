#!/usr/bin/fish
yes | cp -rf "$__fish_config_dir/functions/extract.fish" ./functions
yes | cp -rf "$__fish_config_dir/fish_variables" ./var
yes | cp -rf "$__fish_config_dir/conf.d/prompt.fish" ./config

