#!/bin/bash

echo "Configuration de la sonde de temperature"

BOOT=/boot/config.txt
LINE='dtoverlay=w1-gpio'

if [[ $(cat $BOOT) =~ ($LINE) ]]; then
  echo "$BOOT : OK"
else
  # This appends a newline at the end of file if not present
  sudo ex -s +"bufdo wq" $BOOT
  echo "$LINE" >> $BOOT
  echo "$BOOT : Fixed"
fi

BOOT=/etc/modules
LINE='w1-gpio'
if [[ $(cat $BOOT) =~ ($LINE) ]]; then
  echo "$BOOT : OK"
else
  # This appends a newline at the end of file if not present
  sudo ex -s +"bufdo wq" $BOOT
  echo "$LINE" >> $BOOT
  echo "$BOOT : Fixed"
fi

BOOT=/etc/modules
LINE='w1-therm'
if [[ $(cat $BOOT) =~ ($LINE) ]]; then
  echo "$BOOT : OK"
else
  # This appends a newline at the end of file if not present
  sudo ex -s +"bufdo wq" $BOOT
  echo "$LINE" >> $BOOT
  echo "$BOOT : Fixed"
fi

echo Configure temperature.service
sudo cp temperature.service /lib/systemd/system/
echo systemd daemon reload
sudo systemctl daemon-reload
echo enable temperature.service
sudo systemctl enable temperature.service
echo restart temperature.service
sudo systemctl restart temperature.service
