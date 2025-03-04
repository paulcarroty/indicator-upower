To add device data, plug in the charger and run the next script:


```
#!/bin/bash

echo -e "status:\n" > power.txt
find /sys/devices/ -name status -type f -exec echo "{}" \; -exec cat {} \; >> power.txt
find /sys/class/power_supply/ -name status -type f -exec echo "{}" \; -exec cat {} \; >> power.txt


echo -e "current_now:\n" >> power.txt
find /sys/devices/ -name current_now -type f -exec echo "{}" \; -exec cat {} \; >> power.txt
find /sys/class/power_supply/ -name current_now -type f -exec echo "{}" \; -exec cat {} \; >> power.txt


echo -e "current:\n" >> power.txt
find /sys/devices/ -name current* -type f -exec echo "{}" \; -exec cat {} \; >> power.txt
find /sys/class/power_supply/ -name current* -type f -exec echo "{}" \; -exec cat {} \; >> power.txt


echo -e "cycle_count:\n" >> power.txt
find /sys/devices -name cycle_count -type f -exec echo "{}" \; -exec cat {} \; >> power.txt
find /sys/class/power_supply/ -name cycle_count -type f -exec echo "{}" \; -exec cat {} \; >> power.txt


echo -e "temp:\n" >> power.txt
find /sys/devices -name temp -type f -exec echo "{}" \; -exec cat {} \; >> power.txt
find /sys/devices -name *temp* -type f -exec echo "{}" \; -exec cat {} \; >> power.txt


echo -e "capacity:\n" >> power.txt
find /sys/devices -name capacity -type f -exec echo "{}" \; -exec cat {} \; >> power.txt
find /sys/devices -name *capacity* -type f -exec echo "{}" \; -exec cat {} \; >> power.txt


echo -e "health:\n" >> power.txt
find /sys/devices -name health -type f -exec echo "{}" \; -exec cat {} \; >> power.txt
find /sys/class/power_supply/ -name health -type f -exec echo "{}" \; -exec cat {} \; >> power.txt


echo -e "udev:\n" >> power.txt
udevadm info /sys/class/power_supply/battery >> power.txt

```

It will generate the file `power.txt`. Then [create new issue](https://github.com/paulcarroty/indicator-upower/issues/new/choose) with name "Data fot device YOUR_DEVICE" and attach the file.
