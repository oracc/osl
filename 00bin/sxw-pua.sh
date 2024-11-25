#!/bin/sh
#
# Create the input files for swx-pua.pos pages
#

puablocks=`cat 00etc/oracc-pua.tab | cut -f5 | sort -u`
for a in $puablocks ; do
    cat 00etc/oracc-pua.tab | grep '	'$a'	' | cut -f1,4,6 | \
	rocox -h -R'<oid xml:id="%1" script="%2"><td class="notes">%3</td></oid>' > 00etc/sxw-pos-$a.xml
done
