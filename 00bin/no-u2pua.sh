#!/bin/sh
# Append new PUA entries for OSL OIDs that have no Unicode assignment
grep '^o[0-9]' $ORACC_BUILDS/osl/02pub/sl/sl.tsv | grep ';ucode' | cut -d';' -f1 >01tmp/have-u.oid
grep '^o[0-9]' $ORACC_BUILDS/osl/02pub/sl/sl.tsv | grep -v ';' | cut -f1 | sort -u >01tmp/all.oid
grep -v -f 01tmp/have-u.oid 01tmp/all.oid | sort -u >01tmp/need-u.oid
grep '^o[0-9]' 00etc/pua.tab | cut -f1 >01tmp/have-pua.oid
grep -v -f 01tmp/have-pua.oid 01tmp/need-u.oid >01tmp/need-pua.oid
00bin/pua-edit.sh
