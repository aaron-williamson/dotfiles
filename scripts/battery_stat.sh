#!/usr/bin/env bash

set -e

battery=$(pmset -g batt | grep InternalBattery-0)
charging=$(awk -v battery="$battery" 'BEGIN{ split(battery, a, ";")
                                             gsub("[[:space:]]", "", a[2])
                                             if (a[2] == "charging" || a[2] == "finishingcharge" ||
                                                 a[2] == "charged")
                                               printf("1")
                                             else
                                               printf("0") }')
percent=$(awk -v battery="$battery" 'BEGIN{ split (battery, a, ";")
                                            split (a[1], b)
                                            printf "%s", b[2] }')
remaining=$(awk -v battery="$battery" 'BEGIN{ split (battery, a, ";")
                                              split (a[3], b)
                                              if (b[1] != "(no")
                                                printf "%s", b[1]
                                              else
                                                printf "0" }')
percent_num=$(awk -v per="$percent" 'BEGIN{ sub("%", "", per)
                                            printf "%s", per }')

if [[ $charging -eq 1 ]]; then
  color=blue
elif [[ $percent_num -ge 70 ]]; then
  color=green
elif [[ $percent_num -lt 70 && $percent_num -ge 30 ]]; then
  color=yellow
elif [[ $percent_num -lt 30 ]]; then
  color=red
fi

status_string="#[fg=$color]"

if [[ $charging -eq 1 ]]; then
  status_string="$status_string ⚡"
else
  status_string="$status_string 🔋"
fi

if [[ "$remaining" != "0" ]]; then
  status_string="$status_string $remaining"
fi

status_string="$status_string $percent #[fg=white]-#[fg=default]"

if [[ $percent != "100%" || $charging -eq 0 ]]; then
  echo "$status_string"
fi
