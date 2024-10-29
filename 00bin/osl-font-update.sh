#!/bin/sh
echo $0
(cd osl
 git pull
 cp 00lib/osl.asl /home/oracc/osl/00lib
)
