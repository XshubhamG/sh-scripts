#!/bin/bash

options="  shutdown\n  lock\n  reboot\n󰗽  logout\n  suspend"

selected_option=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme themes/powermenu.rasi -l 5)

# Execute action based on selected option
case "$selected_option" in
"  shutdown")
  systemctl poweroff
  ;;
"  reboot")
  systemctl reboot
  ;;
"󰗽  logout")
  killall bar.sh chadwm
  ;;
"  suspend")
  systemctl suspend
  ;;
"  lock")
  betterlockscreen -l dimblur
  ;;
*)
  exit 0
  ;;
esac
