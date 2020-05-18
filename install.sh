#!/bin/bash

# config file
mkdir -p "$HOME/.config/ceu"
cp "./config" "$HOME/.config/ceu"

# executables
sudo cp "./compress" "/usr/bin"
sudo cp "./encrypt" "/usr/bin"
sudo cp "./compress-and-encrypt" "/usr/bin"
sudo cp "./upload" "/usr/bin"

# systemd service and timer
mkdir -p "$HOME/.config/systemd/user"
cp "./ceu.service" "$HOME/.config/systemd/user"
cp "./ceu.timer" "$HOME/.config/systemd/user"
systemctl --user daemon-reload
systemctl --user enable ceu.timer

# allow user services to run without login
sudo loginctl enable-linger "$USER"

# start the timer right away
systemctl --user start ceu.timer