#!/bin/bash

echo " -- Recovered functions:"
nm /root/sshd.unstripped -D|grep "T function"|wc -l

