#!/bin/bash

if [ "$1" == "" ]
then
	echo "Usage: $0 application"
	exit
fi

nm /root/${1}.unstripped -D|grep "T function"|while read input; do offset=`echo $input|awk '{print $1}'`; found=`nm /root/${1}.dbg |grep $offset|wc -l` ; if [ "$found" == "0" ]; then echo "ERROR: $input: $found" ; fi ; done
