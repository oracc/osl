#!/bin/sh
# Append new PUA entries for tokens, i.e., ns:sign combinations that
# may not have OIDs The tokens must be in 01tmp/tok4pua.lst, one token
# per line; tokens must contain a prefix+colon
if [ ! -r 01tmp/tok4pua.lst ]; then
    echo $0: 'missing 01tmp/tok4pua.lst. Stop.'
    exit 1
fi
grep -v '^o[0-9]' 00etc/pua.tab | grep ':' | cut -f1 >01tmp/have-pua.tok
grep -v -f 01tmp/have-pua.tok 01tmp/tok4pua.lst >01tmp/need-pua.oid
00bin/pua-edit.sh
