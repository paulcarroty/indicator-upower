#!/bin/bash

set -e

mkdir -p /home/phablet/.config/systemd/user
mkdir -p /home/phablet/.local/share/unity/indicators/

# TODO
# mkdir -p /home/phablet/.local/share/ayatana/indicators/


cp -v $(dirname "${BASH_SOURCE[0]}")/indicator.upower.ernesst/current/indicator/indicator-upower.service /home/phablet/.config/systemd/user/
cp -v $(dirname "${BASH_SOURCE[0]}")/indicator.upower.ernesst/current/indicator/upower.indicator /home/phablet/.local/share/unity/indicators/

# /home/phablet/.local/share/ayatana/indicators/

systemctl --user enable indicator-upower.service


echo "indicator-upower installed!"
