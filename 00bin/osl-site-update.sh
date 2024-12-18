#!/bin/sh
# this script is called by /home/oracc/bin/orc
echo $0
rm -f nohup.out
nohup oracc build &
