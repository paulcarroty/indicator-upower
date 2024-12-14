#!/bin/bash

set -e
systemctl --user stop indicator-upower.service
systemctl --user disable indicator-upower.service

rm /home/phablet/.config/systemd/user/indicator-upower.service
rm /home/phablet/.local/share/ayatana/indicators/upower.indicator

echo "indicator-upower uninstalled!"
