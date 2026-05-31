# Battery Charge Limiting on Fairphone 5

### Overview
It is possible to limit battery charging on the Fairphone 5 without root permissions using the user_fcc sysfs interface. Note that the system will continue to report the device as "charging" even when charging has been halted — the effect is only observable via external measurement equipment.

### Key Interface

* `/sys/class/power_supply/battery/user_fcc` - user-writable file that sets the maximum battery capacity
* `/sys/class/power_supply/battery/charge_full` -	 usable full charge (µAh), slightly lower than design capacity
* `/sys/class/power_supply/battery/charge_full_design` -	factory-rated full charge capacity (µAh)

### How It Works
Writing `0` to user_fcc causes the device to treat the battery as already full, stopping the charging process. Writing a large value (at minimum equal to `charge_full`) re-enables charging.

### Calculating a Charge Threshold
To stop charging at a specific percentage, multiply `charge_full` by the desired threshold:

```
charge_limit = charge_full × threshold_percent / 100
Example (80% limit):
4251000 × 0.8 = 3400800

```

⚠️ Known issue: Setting user_fcc to a calculated percentage value does not appear to stop charging at the expected level. The root cause is under investigation — possible causes include incorrect assumptions about user_fcc semantics or a unit mismatch between user_fcc and charge_full.


* Stop charging immediately: `echo 0 > /sys/class/power_supply/battery/user_fcc`
* Resume charging:	`echo $(cat /sys/class/power_supply/battery/charge_full) > /sys/class/power_supply/battery/user_fcc`



* `charge_control.sh`:

```bash
#!/usr/bin/env bash

# Path to capacity file (adjust if needed)
CAP_FILE="/sys/class/power_supply/battery/capacity"
UFCC_FILE="/sys/class/power_supply/battery/user_fcc"
FULL_CAP_FILE="/sys/class/power_supply/battery/charge_full"

# Threshold to compare against (integer 0-100)
THRESHOLD=80

# Commands to run
ON_GE="echo 0 > ${UFCC_FILE}" #echo Battery >= threshold: do X here
ON_LT="echo `cat ${FULL_CAP_FILE}` > ${UFCC_FILE}" #echo Battery < threshold: do Y here

# Read capacity safely
if [[ ! -r "$CAP_FILE" ]]; then
  echo "Error: cannot read $CAP_FILE" >&2
  exit 2
fi

# Trim whitespace and ensure integer
capacity=$(tr -d ' \t\n\r' < "$CAP_FILE")
if ! [[ $capacity =~ ^[0-9]+$ ]]; then
  echo "Error: capacity value is not an integer: '$capacity'" >&2
  exit 3
fi

# TODO: same checks as capacity for UFCC/FULL_CAP after proof of concept and further testing.

# Compare as integers
if (( capacity >= THRESHOLD )); then
  eval "$ON_GE"
else
  eval "$ON_LT"
fi

exit 0
```

* `charge_control.service`:

```ini
[Unit]
Description=Battery charge control script

[Service]
Type=oneshot
ExecStart=/usr/bin/charge_control.sh
User=root
```

* `charge_control.timer`:

```ini
[Unit]
Description=Run charge_control every 1 minute

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Persistent=false

[Install]
WantedBy=timers.target

```

