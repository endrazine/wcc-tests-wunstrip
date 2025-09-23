#!/bin/bash

echo " -- Recovered functions:"
nm /root/nginx.unstripped -D|grep "T function"|wc -l
