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

sudo cp temperature.service /lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable temperature.service
sudo systemctl start temperature.service
