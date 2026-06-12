#!/bin/sh
#
# Create the input files for swx-pua.pos pages
#
xpua=01tmp/oracc-pua.tab
grep -v '^[-#]' 00etc/oracc-pua.tab >$xpua
puablocks=`cat ${xpua} | cut -f5 | sort -u`
for a in $puablocks ; do
    cat ${xpua} | grep '	'$a'	' | cut -f1,4,6 | \
	rocox -h -R'<oid xml:id="%1" script="%2"><td class="notes">%3</td></oid>' > 00etc/sxw-pos-$a.xml
done
