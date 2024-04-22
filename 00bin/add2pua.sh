#!/bin/sh
# Append new PUA entries for OSL @useq entries to 00etc/pua.tab
grep '^o[0-9]' $ORACC_BUILDS/osl/02pub/sl/sl.tsv | grep ';ucode' | grep -v 'U+' | cut -d';' -f1 >01tmp/useq.oid
grep '^o[0-9]' 00etc/pua.tab | cut -f1 >01tmp/have-useq.oid
grep -v -f 01tmp/have-useq.oid 01tmp/useq.oid >01tmp/need-useq.oid
nextpua=`tail -1 00etc/pua.tab | cut -f2`
if [ "$nextpua" == "" ]; then
    echo $0: 'bad PUA tab entry (blank line at EOF?). Stop.'
    exit 1
fi
for a in `cat 01tmp/need-useq.oid`; do
    nextpua=`echo "obase=ibase=16;$nextpua+1"|bc`
    printf "$a\t$nextpua\n" >>00etc/pua.tab
done
