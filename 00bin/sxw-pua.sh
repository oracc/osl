#!/bin/sh
#
# Create the input files for swx-pua.pos pages
#

puablocks=`grep Xsux 00etc/oracc-pua.tab | cut -f5 | sort -u`
for a in $puablocks ; do
    grep Xsux 00etc/oracc-pua.tab | grep $a'$' | cut -f1 >00etc/sxw-pos-$a.txt
done
