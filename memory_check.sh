#!/bin/bash

function requirements(){
	echo "Requirements:"
	echo "   -c: critical threshold (percentage)"
	echo "   -w: warning threshold (percentage)"
	echo "   -e: email address to send the report"
}

while getopts ":c:w:e:" a; do
	case "${a}" in
		c) CRITICAL=${OPTARG} ;;
		w) WARNING=${OPTARG} ;;
		e) EMAIL=${OPTARG} ;;
	esac
done

if [ ${OPTIND} -lt 6 ]; then
	requirements;
else
	if [ ${CRITICAL} -lt ${WARNING} ]; then
		requirements;
	else
		USED_MEMORY=$( free | grep Mem: | awk '{ print $3*100/$2 }')
		USED=${USED_MEMORY/.*}
	fi
fi

if [ ${USED} -ge ${CRITICAL} ]; then
	exit 2
elif [ ${USED} -ge ${WARNING} ]; then
	exit 1
elif [ ${USED} -lt ${WARNING} ]; then
	exit 0
fi
