#!/bin/bash

set -e

echo " | $(pmset -g batt | awk '/InternalBattery-0/{sub(";",""); print $2}') | "
