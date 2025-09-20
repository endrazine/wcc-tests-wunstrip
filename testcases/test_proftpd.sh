#!/bin/bash

echo " -- Recovered functions:"
nm /root/proftpd.unstripped -D|grep "T function"|wc -l

echo " -- Valid functions recovered:"
nm /root/proftpd.unstripped -D|grep "T function"|awk '{print $1}'|while read myaddress; do nm /root/nginx.dbg |grep $myaddress|head -n 1 ; done|wc -l

echo " -- Number of functions we should have found:"
nm /root/proftpd.dbg |grep -wi t|awk '{print $1}'|sort -u|wc -l
