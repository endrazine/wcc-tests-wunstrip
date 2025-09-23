#!/bin/bash

echo " -- Recovered functions:"
nm /root/vlc.unstripped -D|grep "T function"|wc -l
