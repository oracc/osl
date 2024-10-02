#!/bin/sh
code=$1
if [ "$code" == "" ]; then
    echo $0: must give code argument. Stop.
    exit 1
fi
nextpua=`grep Xsux 00etc/oracc-pua.tab | tail -1 | cut -f3`
while IFS= read input
do
    nextpua=`echo "obase=ibase=16;$nextpua+1"|bc`
    printf "$input\t$nextpua\tXsux\t$code\n"
done
