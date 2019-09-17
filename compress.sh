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

# removes the current zipped file
if [ -f "$target".zip ]; then
    rm "$target".zip;
fi

# zips the target folder
zip -9 -r "$target" "$source" -x $(
    # appending all excluded folders
    for i in "${exclude[@]}"; do
        echo "$i";
    done
)
