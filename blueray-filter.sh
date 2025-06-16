#!/bin/sh

# This script toggles the Redshift blue light filter.
# It checks if Redshift is currently running.
# If Redshift is running, it disables the filter (redshift -x).
# If Redshift is not running, it applies a blue light filter with a color temperature of 4000K (redshift -P -O 4000).

# Check if Redshift is currently running
if pgrep "redshift" >/dev/null; then
  echo "Redshift is running. Disabling blue light filter..."
  redshift -x
else
  echo "Redshift is not running. Applying blue light filter with 4000K temperature..."
  # -P: Reset color temperature and brightness before applying new ones.
  # -O 4000: Set color temperature to 4000K.
  redshift -P -O 4000 &
  # The '&' sends the redshift command to the background, allowing the script to exit immediately.
  # This is typical behavior for background applications like Redshift.
fi

echo "Toggle complete."
