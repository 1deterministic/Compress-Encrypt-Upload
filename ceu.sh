#!/bin/bash

# requires zip gpg rclone
# you can do something like './ceu.sh >> log.txt & disown' to detach it from the terminal window and probe its status with 'tail -1 log.txt'

# gpg email
gpg_id="email@domain.com"

# dirs used and excluded files/folders
source="/path/to/source" # is a folder
target="/path/to/target" # is a file
exclude=("path/to/source/.*" "path/to/source/ignorethis") # these inside $source are ignored, notice the lack of '/' at the start of the strings (zip -x format)

# remote location to send the encrypted file
remote="remotename:/" # rclone format

# location of the counter files
config="path/to/config" # is a folder and must already exist

# counts the number of times this script has runned
day="$config/day"
week="$config/week"

# stop execution if $config is not a folder
if [ ! -d "$config" ]; then
    echo "$config is not a folder!"
    exit 1
fi

# create counter at 0 if doesn't exist
if [ ! -f "$day" ]; then
    echo 0 > "$day"
fi

# create counter at 0 if doesn't exist
if [ ! -f "$week" ]; then
    echo 0 > "$week"
fi

# compressing the target folder
zip -9 -r "$target" "$source" -x $(
    # appending all excluded folders
    for i in "${exclude[@]}"; do
        echo "$i";
    done
)

# removes the current encrypted file
if [ -f "$target" ]; then
    rm "$target";
fi

# encrypting the compressed file
gpg -o "$target" -r "$gpg_id" --encrypt "$target".zip

# removes compressed file now that it is no longer needed
if [ -f "$target".zip ]; then
    rm "$target".zip;
fi

# if 4 weeks passed, promotes the currently uploaded weekly backup to a monthly one (remote only copy)
if [ $(cat "$week") -ge 4 ]; then
    echo 0 > "$week"
    rclone copyto "$remote/weekly" "$remote/monthly" --progress --stats-one-line
fi

# if 7 days passed, updates the weekly backup
if [ $(cat "$day") -ge 7 ]; then
    echo 0 > "$day"
    echo $(($(cat "$week") + 1)) > "$week"
    rclone copyto "$target" "$remote/weekly" --progress --stats-one-line
else
    echo $(($(cat "$day") + 1)) > "$day"
fi

echo "Done!"