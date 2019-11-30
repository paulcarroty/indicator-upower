#!/bin/bash

set -e

rm /home/phablet/.config/upstart/ernesst-indicator-upower.conf
rm /home/phablet/.local/share/unity/indicators/com.ernesst.indicator.upower

echo "indicator-upower uninstalled"
