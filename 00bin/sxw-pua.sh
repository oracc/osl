#!/bin/sh
#
# Create the input files for swx-pua.pos pages
#

puablocks=`grep Xsux 00etc/oracc-pua.tab | cut -f5 | sort -u`
for a in $puablocks ; do
    grep Xsux 00etc/oracc-pua.tab | grep '	'$a'	' | cut -f1,6 | \
	rocox -h -R'<oid xml:id="%1"><td class="notes">%2</td></oid>' > 00etc/sxw-pos-$a.xml
done
