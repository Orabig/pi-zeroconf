#!/bin/sh

BASE=/sys/bus/w1/devices
GRAPHITE=$1

while true; do
  for file in $BASE/28-*
  do
    probe=${file##*/28-}
    echo -n "Read probe 28-$probe : "
    if grep -E 'crc.* YES' $BASE/28-$probe/w1_slave > /dev/null
    then
	    TEMP=$(cat $BASE/28-$probe/w1_slave | perl -ne 'print $1/1000.0 if /t=(\d+)/')
	    echo $TEMP'°'
	    echo -n "home.temp.$probe:$TEMP|g" | nc -w 1 -u $GRAPHITE 8125
	else
		echo "crc not ok"
	fi
  done

  sleep 5
done




