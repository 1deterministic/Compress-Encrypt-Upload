#!/bin/bash

if [[ $(whoami) == "root" ]]; then echo "Please run this script as a regular user"; echo "Closing"; exit 1; fi

echo "CEU requires tar, gzip, gpg and rclone with a gpg key and a rclone remote both available, you can pause here and check that before running. If everything is ok, type OK (all caps)"
read answer
if [[ ! "$answer" == "OK" ]]; then echo "Closing"; exit 1; fi

mkdir "$HOME/.config"
mkdir "$HOME/.config/systemd"
mkdir "$HOME/.config/systemd/user"
mkdir "$HOME/.local"
mkdir "$HOME/.local/bin"

# changes ./config to $HOME/.config/ceu and sends the main files to $HOME/.local/bin
sed "s|./config|$HOME/.config/ceu|g" "compress" > "$HOME/.local/bin/compress"; chmod +x "$HOME/.local/bin/compress"
sed "s|./config|$HOME/.config/ceu|g" "encrypt" > "$HOME/.local/bin/encrypt"; chmod +x "$HOME/.local/bin/encrypt"
sed "s|./config|$HOME/.config/ceu|g" "upload" > "$HOME/.local/bin/upload"; chmod +x "$HOME/.local/bin/upload"

# installs the config file
cp "config" "$HOME/.config/ceu"; chmod +x "$HOME/.config/ceu"

# installs the systemd user service
sed "s|/path/to/compress|$HOME/.local/bin/compress|g;s|/path/to/encrypt|$HOME/.local/bin/encrypt|g;s|/path/to/upload|$HOME/.local/bin/upload|g" "ceu.service" > "$HOME/.config/systemd/user/ceu.service"
cp "ceu.timer" "$HOME/.config/systemd/user/ceu.timer"
systemctl --user daemon-reload
systemctl --user enable ceu.timer

echo "Now you can edit $HOME/.config/ceu with the values you want"
echo "You can also run loginctl enable-linger $USER as root if you want to allow the timer to run even if $USER is not logged in"