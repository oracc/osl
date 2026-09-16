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
