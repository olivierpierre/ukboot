#!/bin/bash

CFG=domain_config.xl
MAX_LOOP=10000
OUTPUT=result

echo "" > $OUTPUT
for i in `seq 0 $MAX_LOOP`; do
	sed -i "s/name = .*/name = \"mini-os$i\"/" $CFG
	xl create $CFG
	if [ ! "$?" == "0" ]; then
		echo "ERROR!"
		exit
	fi
	echo "$i/$MAX_LOOP - success" >> $OUTPUT
done
