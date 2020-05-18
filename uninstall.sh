#!/bin/bash

# stop the timer
systemctl --user stop ceu.timer

# disallow user services to run without login 
sudo loginctl disable-linger "$USER"

# systemd service and timer
systemctl --user disable ceu.timer
rm "./ceu.service" "$HOME/.config/systemd/user"
rm "./ceu.timer" "$HOME/.config/systemd/user"
systemctl --user daemon-reload

# config file (uncomment to remove the config file)
# rm -r "$HOME/.config/ceu"

# executables
sudo rm "/usr/bin/compress"
sudo rm "/usr/bin/encrypt"
sudo rm "/usr/bin/compress-and-encrypt"
sudo rm "/usr/bin/upload"