#!/bin/bash

echo " -- Recovered functions:"
nm /root/postgres.unstripped -D|grep "T function"|wc -l
