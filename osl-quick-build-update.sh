#!/bin/sh
scp 02pub/sl/sl.tsv build:/home/oracc/osl/02pub/sl/
ssh -C build '(cd /home/oracc/osl ; /home/oracc/bin/slix -b)'
ssh -C build 'ls -l /home/oracc/osl/02pub/sl'
