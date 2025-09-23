#!/bin/bash

echo " -- Recovered functions:"
nm /root/libjpeg.so.9.5.0.unstripped -D|grep "T function"|wc -l
