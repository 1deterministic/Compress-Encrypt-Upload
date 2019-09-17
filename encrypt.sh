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

# removes the current encrypted file
if [ -f "$target" ]; then
    rm "$target";
fi

# encrypting the compressed file
gpg -o "$target" -r "$gpg_id" --encrypt "$target".zip
