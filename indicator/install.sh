#!/bin/bash

set -e

mkdir -p /home/phablet/.config/upstart/
mkdir -p /home/phablet/.local/share/unity/indicators/

cp -v /opt/click.ubuntu.com/indicator.upower.ernesst/current/indicator/ernesst-indicator-upower.conf /home/phablet/.config/upstart/
cp -v /opt/click.ubuntu.com/indicator.upower.ernesst/current/indicator/com.ernesst.indicator.upower /home/phablet/.local/share/unity/indicators/

echo "indicator-upower installed!"
