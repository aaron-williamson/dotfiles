#!/usr/bin/env bash

set -e

battery=$(pmset -g batt | grep InternalBattery-0)
charging=$(awk -v battery="$battery" 'BEGIN{ split(battery, a);
                                             if (a[3] == "charging;" || a[3] == "finishing" ||
                                                 a[3] == "charged;")
                                               printf "1";
                                             else
                                               printf "0" }')
percent=$(awk -v battery="$battery" 'BEGIN{ split (battery, a);
                                            sub(";", "", a[2]);
                                            printf "%s", a[2] }')
remaining=$(awk -v battery="$battery" 'BEGIN{ split (battery, a);
                                              printf "%s", a[4] }')
status_string=" |"

if [[ $charging -eq 1 ]]; then
  status_string="$status_string ⚡"
else
  status_string="$status_string 🔋"
fi

if [[ $remaining != "(no" && $remaining != "charge;" ]]; then
  status_string="$status_string $remaining"
fi

status_string="$status_string $percent | "

if [[ $percent != "100%" || $charging -eq 0 ]]; then
  echo "$status_string"
fi
