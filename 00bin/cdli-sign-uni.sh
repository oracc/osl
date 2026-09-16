#!/bin/sh
catf=cdli-sign.atf
>$catf cat <<EOF
&X121212 = CDLI SIGN LIST
#project: epsd2
EOF
cut -f1-3 00etc/cdli-sign-readings-current.tsv | sed 's/	/.	/' | atf2uni.plx | \
    cdli-sign-fix-atf.plx | grep -v ^id >>$catf
