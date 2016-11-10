#!/bin/bash
set -euo pipefail

# Boot X unikernels

if [ ! "$#" == "1" ]; then
	echo "Usage: $0 <config file>"
	exit
fi

source $1

# Clean tmp dir and output file
rm -rf $TMPDIR && mkdir -p $TMPDIR


for index in `seq 1 $TO_BOOT`; do
	# Generate config file
	config_file=$TMPDIR/uk$index.cfg
	echo "kernel = \"$RUNNING_UK\"" > $config_file
	echo "memory = $UK_MEMORY" >> $config_file
	echo "on_crash = 'destroy'" >> $config_file
	echo "name = \"$BG_BASENAME$index\"" >> $config_file
	echo "vcpus = 1" >> $config_file

	# Boot it
	xl create-client create $config_file
	echo "  Booted BG $index / $last_iteration"
done

