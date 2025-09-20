#!/bin/bash

echo " -- Recovered functions:"
nm /root/ls.unstripped -D|grep "T function"|wc -l

echo " -- Valid functions recovered:"
nm /root/ls.unstripped -D|grep "T" -wi|awk '{print $1}'|while read myaddress; do nm /root/ls.dbg |grep $myaddress|head -n 1 ; done|wc -l

echo " -- Number of functions we should have found:"
nm /root/ls.dbg |grep -wi t|awk '{print $1}'|sort -u|wc -l


