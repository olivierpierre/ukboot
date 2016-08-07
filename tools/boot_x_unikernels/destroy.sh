#!/bin/bash
set -euo pipefail

if [ ! "$#" == "1" ]; then
	echo "Usage: $0 <Config file>"
	exit
fi

source $1

for i in `seq 1 $NUM`; do
	xl destroy $BASENAME$i
    echo "  Destroyed $i / $NUM"
done
