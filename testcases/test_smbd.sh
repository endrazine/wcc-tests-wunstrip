#!/bin/bash

echo " -- Recovered functions:"
nm /root/smbd.unstripped -D|grep "T function"|wc -l
