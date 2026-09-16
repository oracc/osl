#!/bin/sh
catf=cdli-sign.atf
>$catf cat <<EOF
&X121212 = CDLI SIGN LIST
#project: cdli
#atf: use ascii
EOF
cut -f1-3 00etc/cdli-sign-readings-current.tsv | \
    00bin/cdli-sign-fix-atf.plx -l | grep -v ^id >>$catf
ax -x $catf 2>cdli-sign-atf.log
xsltproc 00bin/cdli-sign-osl.xsl ax.xml >cdli-sign-osl-in.tsv
00bin/catf-alias.plx >00etc/cdli-sign-osl.tsv 2>catf-alias.err
wc -l catf-alias.err
