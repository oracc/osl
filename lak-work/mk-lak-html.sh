#!/bin/sh
grep ^LAK /home/oracc/osl/02pub/lists.tsv | tail -n +2 | sort -u >list-lak.tsv
