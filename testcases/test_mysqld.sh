#!/bin/bash

echo " -- Recovered functions:"
nm /root/mysqld.unstripped -D|grep "T function"|wc -l
