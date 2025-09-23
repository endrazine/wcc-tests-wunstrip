#!/bin/bash

echo " -- Recovered functions:"
nm /root/ls.unstripped -D|grep "T function"|wc -l
