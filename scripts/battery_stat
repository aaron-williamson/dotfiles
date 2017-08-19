#!/usr/bin/env bash

set -e

battery=$(pmset -g batt | grep InternalBattery-0)
battery_status=$(echo "${battery}" | sed -n -e $'s/^.*\t//p')
plugged_in=$(awk -v battery="$battery_status" 'BEGIN{ split(battery, a, ";")
                                             sub("[[:space:]]", "", a[2])
                                             if (a[2] == "charging" || a[2] == "finishingcharge" ||
                                                 a[2] == "charged" || a[2] == "ACattached")
                                               printf("true")
                                             else
                                               printf("false") }')
percent=$(awk -v battery="$battery_status" 'BEGIN{ split (battery, a, ";")
                                            printf "%s", a[1] }')
remaining=$(awk -v battery="$battery_status" 'BEGIN{ split (battery, a, ";")
                                              split (a[3], b)
                                              if (b[1] != "(no" && b[1] != "not")
                                                printf "%s", b[1]
                                              else
                                                printf "false" }')
percent_num=$(awk -v per="$percent" 'BEGIN{ sub("%", "", per)
                                            printf "%s", per }')

if [[ "${plugged_in}" == "true" ]]; then
  color=blue
elif [[ $percent_num -ge 70 ]]; then
  color=green
elif [[ $percent_num -lt 70 && $percent_num -ge 30 ]]; then
  color=yellow
elif [[ $percent_num -lt 30 ]]; then
  color=red
fi

status_string="#[fg=${color}]"

if [[ "${plugged_in}" == "true" ]]; then
  status_string="${status_string} ⚡"
else
  status_string="${status_string} 🔋"
fi

if [[ "${remaining}" != "false" ]]; then
  status_string="${status_string} ${remaining}"
fi

status_string="${status_string} ${percent} #[fg=yellow]-#[fg=default]"

if [[ $percent_num -ne 100 ]] || [[ "${plugged_in}" == "false" ]]; then
 echo "${status_string}"
fi
