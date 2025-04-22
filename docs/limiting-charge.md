This feature depends on Linux kernel. There are two ways to enable it for userspace:
- Create a bug request against your device's repository and mention this [commit](https://github.com/Halium/android_device_oneplus_oneplus3/pull/10/commits/f9154c467c0f6c6d9748f9d854dff01b44cce66f)
- Use udev rules: create the file `/etc/udev/rules.d/90-charging_enabled.rules` with the following content:

```
ACTION=="add|change", SUBSYSTEM=="power_supply", KERNEL=="battery", RUN+="/bin/sh -c  'f=/sys/class/power_supply/battery/charging_enabled; /bin/test -e $f && /bin/chmod 0664 $f && /bin/chown phablet $f'"
ACTION=="add|change", SUBSYSTEM=="power_supply", KERNEL=="battery", RUN+="/bin/sh -c  'f=/sys/class/power_supply/battery/battery_charging_enabled; /bin/test -e $f && /bin/chmod 0664 $f && /bin/chown phablet $f'"
```

The second way is now automated in [Udev rules installer #21](https://github.com/paulcarroty/indicator-upower/pull/21) and requires the installed indicator and reboot. If limiting the charge still doesn't work, please create a new issue and attach [power.txt](https://github.com/paulcarroty/indicator-upower/blob/master/docs/add_device.md). 
