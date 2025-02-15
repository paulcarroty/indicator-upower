# Indicator upower for Ubuntu Touch 

#### fork of [indicator-upower](https://gitlab.com/ernesst/indicator-upower), which is [Indicator Weather](https://gitlab.com/bhdouglass/indicator-weather/) spin-off


The application uses data from Linux API and the [Upower](https://upower.freedesktop.org/) cli command.

Upower is **devices dependent, please** [submit your device data](https://github.com/paulcarroty/indicator-upower/blob/master/docs/add_device.md) to handle more info.

<div id="openstore-logo" align="center">
<a href="https://open-store.io/app/indicator.upower.ernesst.fork"><img src="https://open-store.io/badges/en_US.png" alt="OpenStore" /></a>

<a href="https://patreon.com/paulcarroty"><img src="https://img.shields.io/badge/donate_on-patreon-f96854?style=for-the-badge" height="40" /></a>  
</div>

*Supported devices*:


|   Devices  | Status |    Current   | Temperature | Charge | Estimated Bat. capacity   |Remaining life  | Limiting battery's charge |Battery Cycle|
|:----------:|:------:|:------------:|:-----------:|:------:|:-------:|:---------------:|:----------------------:|:----------------------:|
|   OP3(T)   |    x   |       x      |      x      |    x   |    x    |        x        |            x           |           x          |
|    mako    |    x   |       x      |      x      |    x   |         |        x        |           no           |                      |
| hammerhead |    x   |       x      |      x      |    x   |         |        no       |           no           |                      |
|   cedric   |    x   |       x      |      x      |    x   |         |        x        |           no           |                      |
|    bacon   |    x   |       x      |      x      |    x   |         |        no       |           no           |                      |
|  vegetahd  |    x   | not reliable |      x      |    x   |         |        no       |           no           |                      |
|  turbo     |    x   |       x      |      x      |    x   |         |        no       |           no           |            x         |
| pinephone  |    x   |       x      |      x      |    x   |         |        no       |           no           |                      |
| suzu       |    x   |       x      |      x      |    x   |         |        no       |           no           |            x         |
| mido       |    x   |       x      |      x      |    x   |         |        no       |           no           |                      |
| miatoll    |    x   |       x      |      x      |    x   |         |        no       |           no           |            x         |
| dumpling   |    x   |       x      |      x      |    x   |         |        x        |           x            |            x         |
| surya/karna|    x   |       x      |      x      |    x   |         |        x        |           x            |            x         |
| FP4        |    x   |       x      |      x      |    x   |         |        x        |           x            |            x         |

## Limiting battery's charge
It's a feature which needs to be enable on the device itself.
- Please create a bug request against the repository of your device and mentions this [commit](https://github.com/Halium/android_device_oneplus_oneplus3/pull/10/commits/f9154c467c0f6c6d9748f9d854dff01b44cce66f)
- Experimental way using udev rules: create the file `/etc/udev/rules.d/90-charging_enabled.rules` with the following content:

```
ACTION=="add|change", SUBSYSTEM=="power_supply", KERNEL=="battery", RUN+="/bin/sh -c  'f=/sys/class/power_supply/battery/charging_enabled; test -e $f && /bin/chmod 0664 $f && /bin/chown phablet $f'"
ACTION=="add|change", SUBSYSTEM=="power_supply", KERNEL=="battery", RUN+="/bin/sh -c  'f=/sys/class/power_supply/battery/battery_charging_enabled; test -e $f && /bin/chmod 0664 $f && /bin/chown phablet $f'"
```

## Installation
- Install the application from OpenStore
- Open to the Upower app, set the all settings the way you like and save
- Install the indicator
- Reboot.

## Translating

Check [indicator-upower.pot](https://github.com/paulcarroty/indicator-upower/blob/master/po/indicator-upower.pot)

## About the Indicator
As for Indicator Weather, the indicator itself is rather simple. It's a python script that exports a Gtk
menu over DBus. To start the script there is an systemd service. This starts the indicator when
Unity starts the rest of the indicators. The other important file is
indicator/upower.indicator. This file lets Unity know where to
find the indicator on DBus and where to place the indicator on the indicator bar.

If you are interested in creating your own indicator for Ubuntu Touch and have
questions, I would be glad to help.
Moreover the Indicator creator, Brian Douglass, can be reached via [his website](https://bhdouglass.com/contact.html).

## Building

The easiest way to compile and package indicator upower is via [clickable](https://github.com/bhdouglass/clickable).

## Logo

The logo is from the [gusbemacbe github repository of Suru-plus icons](https://github.com/gusbemacbe/suru-plus).

## Donate

Please consider giving a small donation to the [Ubports project](https://ubports.com/donate) and [the contributors](https://github.com/paulcarroty/indicator-upower/graphs/contributors).

## License [GPLv3](https://github.com/paulcarroty/indicator-upower/blob/master/LICENSE)
