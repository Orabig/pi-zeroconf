#!/bin/sh

BASE=/sys/bus/w1/devices
GRAPHITE=$1

while true; do
  for file in $BASE/28-*
  do
    probe=${file##*/28-}
    echo -n "Read probe 28-$probe : "
    TEMP=$(cat $BASE/28-$probe/temperature | perl -pe '$_/=1000.0')
    echo $TEMP'°'
    echo -n "home.temp.$probe:$TEMP|g" | nc -w 1 -u $GRAPHITE 8125
  done

  sleep 5
done




