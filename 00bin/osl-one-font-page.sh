#!/bin/sh
f=$1
c=$2
o=${ORACC}/lib/data/$f.ofpx
h=00etc/$c.xml
if [ ! -r $o ]; then
    o2=/Users/stinney/oracc2/lib/fonts/$f.ofpx
    if [ ! -r $o2 ]; then
	echo $0: required $o or $o2 not found. Stop.
	exit 1
    else
	o=$o2
    fi
fi
if [ ! -r $h ]; then
    echo $0: required $h not found. Stop.
    exit 1
fi
if [ "$c" == "" ]; then
    echo $0: CSS code for $f not given. Stop.
    exit 1
fi

mkdir -p 00web/fonts
x=00web/fonts/$c.xml
grep -v '</body>' $h >$x
xsltproc -stringparam css $c 00bin/ofpx2html.xsl $o >>$x
tail -1 $h >>$x
