#!/bin/sh
# Append new PUA entries for OSL @useq entries to 00etc/pua.tab
grep '^o[0-9]' $ORACC_BUILDS/osl/02pub/sl/sl.tsv | grep ';ucode' | grep -v 'U+' | cut -d';' -f1 >01tmp/useq.oid
grep '^o[0-9]' 00etc/pua.tab | cut -f1 >01tmp/have-pua.oid
grep -v -f 01tmp/have-pua.oid 01tmp/useq.oid >01tmp/need-pua.oid
00bin/pua-edit.sh
