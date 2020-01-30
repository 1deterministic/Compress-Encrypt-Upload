#!/bin/bash

if [ $(whoami) == "root" ]; then echo "Please run this script as a regular user"; exit 1; fi

systemctl --user disable ceu.timer
rm "$HOME/.config/systemd/user/ceu.service"
rm "$HOME/.config/systemd/user/ceu.timer"
systemctl --user daemon-reload

rm "$HOME/.local/bin/compress"
rm "$HOME/.local/bin/encrypt"
rm "$HOME/.local/bin/upload"
rm "$HOME/.config/ceu"

echo "Removed all CEU files but the compressed and encrypted files were not touched"
echo "If you enabled the user the run services without login with loginctl enable-linger $USER you may want to disable that with loginctl disable-linger $USER as root"