#!/bin/bash

set -e

mkdir -p /home/phablet/.config/systemd/user
mkdir -p /home/phablet/.local/share/ayatana/indicators/


cp -v /opt/click.ubuntu.com/indicator.upower.ernesst.fork/current/indicator/indicator-upower.service /home/phablet/.config/systemd/user/
cp -v /opt/click.ubuntu.com/indicator.upower.ernesst.fork/current/indicator/upower.indicator /home/phablet/.local/share/ayatana/indicators/


systemctl --user enable indicator-upower.service


echo "indicator-upower installed!"
