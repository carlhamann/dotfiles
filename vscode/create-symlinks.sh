#!/bin/bash

files=("settings.json" "keybindings.json")
target_dir="$(dirname "$0")"
symlink_dir="$HOME/Library/Application Support/Code/User/"

for file in "${files[@]}"; do
    link_path="$symlink_dir$file"
    target_path="$target_dir/$file"

    # Remove existing symlink if it exists
    if [ -L "$link_path" ] || [ -e "$link_path" ]; then
        echo "Deleting existing symlink: $link_path"
        rm -f "$link_path"
    fi

    # Print before creating new symlink
    echo "Creating symlink: $link_path -> $target_path"
    ln -s "$target_path" "$link_path"
done
