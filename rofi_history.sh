#!/bin/bash

# Ensure the tilde is expanded and spaces are handled correctly
ROFI_THEME="$HOME/.config/rofi/launchers/type-1/style-11.rasi"

# Set CM_LAUNCHER for clipmenu
CM_LAUNCHER="rofi -dmenu -theme $ROFI_THEME -p 'Clipboard:'" clipmenu
