#!/bin/bash

echo " -- Recovered functions:"
nm /root/liblzma.so.5.unstripped -D|grep "T function"|wc -l
