#!/bin/bash 

# location of the config file
config="./config.sh"

# tries to load the config file
if [ -f "$config" ]; then
    source "$config"
else
    echo "$config is not a file!"
    exit 1
fi

# uploads the encrypted file to the remote service
rclone copyto "$target" "$remote" --progress --stats-one-line
