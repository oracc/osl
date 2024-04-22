#!/bin/sh
# Create a convenience table of all OSL Unicode mappings covering OIDs
# and also token entries in 00etc/pua.tab
grep '^o[0-9]' $ORACC_BUILDS/osl/02pub/sl/sl.tsv | grep ';ucode' \
    | grep 'U+' | sed 's/;ucode//' | sed s'/U+//' >00etc/ucp.tab
grep '^o[0-9]\|:' 00etc/pua.tab >01tmp/pua.ucp >>00etc/ucp.tab
