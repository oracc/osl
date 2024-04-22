#!/bin/sh
nextpua=`tail -1 00etc/pua.tab | cut -f2`
if [ "$nextpua" == "" ]; then
    echo $0: 'bad PUA tab entry (blank line at EOF?). Stop.'
    exit 1
fi
for a in `cat 01tmp/need-useq.oid`; do
    nextpua=`echo "obase=ibase=16;$nextpua+1"|bc`
    printf "$a\t$nextpua\n" >>00etc/pua.tab
done
