#!/bin/bash

# config file
mkdir -p "$HOME/.config/ceu"
cp "./config" "$HOME/.config/ceu"

# executables
sudo cp "./compress" "/usr/bin" && chmod +x "/usr/bin/compress"
sudo cp "./encrypt" "/usr/bin" && chmod +x "/usr/bin/encrypt"
sudo cp "./compress-and-encrypt" "/usr/bin" && chmod +x "/usr/bin/compress-and-encrypt"
sudo cp "./upload" "/usr/bin" && chmod +x "/usr/bin/upload"

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
