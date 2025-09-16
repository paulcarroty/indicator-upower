#!/bin/bash

set -e

mkdir -p /home/phablet/.config/systemd/user || { echo "ERROR: failed to create ~/.config/systemd/user"; exit 1; }
mkdir -p /home/phablet/.local/share/ayatana/indicators/ || { echo "ERROR: failed to create ~/.local/share/ayatana/indicators/"; exit 1; }

cp -v /opt/click.ubuntu.com/indicator.upower.ernesst.fork/current/indicator/indicator-upower.service /home/phablet/.config/systemd/user/ || { echo "ERROR: failed to copy indicator-upower.service"; exit 1; }
cp -v /opt/click.ubuntu.com/indicator.upower.ernesst.fork/current/indicator/upower.indicator /home/phablet/.local/share/ayatana/indicators/ || { echo "ERROR: failed to copy upower.indicator"; exit 1; }

systemctl --user daemon-reload 
systemctl --user enable --now indicator-upower.service


echo "indicator-upower installed!"
