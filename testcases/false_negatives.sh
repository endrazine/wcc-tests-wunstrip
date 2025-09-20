#!/bin/bash

if [ "$1" == "" ]
then
	echo "Usage: $0 application"
	exit
fi

nm /root/${1}.dbg |grep -w t|while read input; do offset=`echo $input|awk '{print $1}'`; found=`nm /root/${1}.unstripped -D|grep $offset|wc -l` ; if [ "$found" -lt "1" ]; then echo "ERROR: $input: $found" ; fi ; done
