#!/bin/bash
set -euo pipefail

if [ ! "$#" == "1" ]; then
	echo "Usage: $0 <config file>"
	exit
fi

source $1

# A function to print the config
print_config ()
{
  setup=`uname -a`
  echo "# --------------"
  echo "# Configuration:"
  echo "# --------------"
  echo "# $setup"
  echo "# PRINT_CONFIG=$PRINT_CONFIG"
  echo "# CURRENTLY_RUNNING=$CURRENTLY_RUNNING"
  echo "# XEN_SRC_DIR=$XEN_SRC_DIR"
  echo "# OUTPUT_FILE=$OUTPUT_FILE"
  echo "# RUNNING_UK=$RUNNING_UK"
  echo "# MEASURED_UK=$MEASURED_UK"
  echo "# UK_MEMORY=$UK_MEMORY"
  echo "# CHRONO=$CHRONO"
  echo "# SAFETYSLEEP=$SAFETYSLEEP"
  echo "# PINNING_M=$PINNING_M"
  echo "# PINNING_BG=$PINNING_BG"
  echo "# PINNING_BGRR_FIRST=$PINNING_BGRR_FIRST"
  echo "# PINNING_BGRR_LAST=$PINNING_BGRR_LAST"
  echo "# BG_BASENAME=$BG_BASENAME"
  echo "# TMPDIR=$TMPDIR"
  echo "# TMPCLEAR=$TMPCLEAR"
  echo "# XS_RESULT=$XS_RESULT"
  echo "# --------------------"
}

# Clean tmp dir and output file
rm -rf $TMPDIR && mkdir -p $TMPDIR
echo "" > $OUTPUT_FILE

# Print the config if needed
if [ "$PRINT_CONFIG" == "yes" ]; then
	print_config >> $OUTPUT_FILE
fi

currently_running_num=0
for current in $CURRENTLY_RUNNING; do
    echo "Currently running pass: $current"

    let number_to_boot="$current - $currently_running_num" || true
    
    # Boot background uks
    let last_iteration="$currently_running_num + $number_to_boot - 1" || true
    for index in `seq $currently_running_num $last_iteration`; do
        # Generate config file
        config_file=$TMPDIR/uk$index.cfg
        echo "kernel = \"$RUNNING_UK\"" > $config_file
        echo "memory = $UK_MEMORY" >> $config_file
        echo "on_crash = 'destroy'" >> $config_file
        echo "name = \"$BG_BASENAME$index\"" >> $config_file
        echo "vcpus = 1" >> $config_file
        
	# RR pinning ?
	if [ "$PINNING_BG" == "rr" ]; then
		let pinning_num="$PINNING_BGRR_LAST - $PINNING_BGRR_FIRST + 1" || true
		let pin_index="$PINNING_BGRR_FIRST + ($index % $pinning_num)" || true
		echo "cpu = $pin_index" >> $config_file
	fi

	# Sub pinning ?
	if [ "$PINNING_BG" == "sub" ]; then
		echo "cpus = \"${PINNING_BGRR_FIRST}-${PINNING_BGRR_LAST}\"" >> $config_file
	fi
	
        # Boot it
        xl create $config_file -q
	echo "  Booted BG $index / $last_iteration"
    done
    echo "  Safety sleep for $SAFETYSLEEP" secs
    sleep $SAFETYSLEEP 

    let currently_running_num="$currently_running_num + $number_to_boot" || true

    # Generate config file for the measured one
    config_file=$TMPDIR/measured.cfg
    echo "kernel = \"$MEASURED_UK\"" > $config_file
    echo "memory = $UK_MEMORY" >> $config_file
    echo "on_crash = 'destroy'" >> $config_file
    echo "name = \"$MEASURED_NAME\"" >> $config_file
    echo "vcpus = 1" >> $config_file
    # Do we need to pin ?
    if [ ! "$PINNING_M" == "no" ]; then
			echo "cpu = $PINNING_M" >> $config_file
	fi
    
    # Setup xenstore entry for result
    xenstore-write $XS_RESULT "0"
    xenstore-chmod $XS_RESULT b$MEASURED_NAME
    
    # Boot it with measurements
    xl_time=`$CHRONO xl create $config_file`
    
    # Wait for results to be available
    phase2=`xenstore-read $XS_RESULT`
    retries=0
    while [ "$phase2" == "0" ]; do
		if [ "$retries" -gt 60 ]; then
			echo "Trying to read xenstore ($retries)"
		fi
		phase2=`xenstore-read $XS_RESULT`
		let retries="$retries + 1" || true
		sleep 1
    done

    # print results
    # TODO incorporate xenstore results here
    echo "$currently_running_num;$xl_time;$phase2" >> $OUTPUT_FILE

    # Should not be needed to destroy it
    
    if [ "$TMPCLEAR" == "yes" ]; then
		rm $config_file
    fi

done

# destroy all unikernels
let last_iteration="currently_running_num - 1" || true
for i in `seq 0 $last_iteration`; do
    xl destroy $BG_BASENAME$i
done

# Clean temp folder if needed
if [ "$TMPCLEAR" == "yes" ]; then
	rm -r $TMPDIR
fi
