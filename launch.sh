#!/bin/bash
# set -euo pipefail

source Config.mk

# Clean tmp dir
rm -rf $TMPDIR && mkdir -p $TMPDIR

currently_running_num=0
for current in $CURRENTLY_RUNNING; do
    let number_to_boot="$current - $currently_running_num"
    
    # Boot background uks
    let last_iteration="$currently_running_num + $number_to_boot - 1"
    for index in `seq $currently_running_num $last_iteration`; do
        # Generate config file
        config_file=$TMPDIR/uk$index.cfg
        echo "kernel = \"$RUNNING_UK\"" > $config_file
        echo "memory = $UK_MEMORY" >> $config_file
        echo "on_crash = 'destroy'" >> $config_file
        echo "name = \"$BG_BASENAME$index\"" >> $config_file

        # Boot it
        xl create $config_file -q
    done
    sleep $SAFETYSLEEP 

    let currently_running_num="$currently_running_num + $number_to_boot"

    # Generate config file for the measured one
    config_file=$TMPDIR/measured.cfg
    echo "kernel = \"$MEASURED_UK\"" > $config_file
    echo "memory = $UK_MEMORY" >> $config_file
    echo "on_crash = 'destroy'" >> $config_file
    echo "name = \"$MEASURED_NAME\"" >> $config_file

    # Boot it with measurements
    # TODO Xenstore stuff here
    xl_time=`$CHRONO xl create $config_file`

    # print results
    # TODO incorporate xenstore results here
    echo "$currently_running_num;$xl_time"

    # Destroy it
    xl destroy $MEASURED_NAME
    rm $config_file

done

# destroy all unikernels
let last_iteration="currently_running_num - 1"
for i in `seq 0 $last_iteration`; do
    xl destroy $BG_BASENAME$i
done

# Clean temp folder
rm -r $TMPDIR
