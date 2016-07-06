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
		echo ${USED_MEMORY}
		USED=${USED_MEMORY/.*}
	fi
fi

if [ ${USED} -ge ${CRITICAL} ]; then
	echo "2"
	exit
elif [ ${USED} -ge ${WARNING} ]; then
	echo "1"
	exit
elif [ ${USED} -lt ${WARNING} ]; then
	echo "0"
	exit
fi
