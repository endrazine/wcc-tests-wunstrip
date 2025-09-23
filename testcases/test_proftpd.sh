#!/bin/bash

echo " -- Recovered functions:"
nm /root/proftpd.unstripped -D|grep "T function"|wc -l
