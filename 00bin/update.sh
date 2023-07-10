#!/bin/sh
chmod +w 00lib/ogsl.asl
(cd ~/orc/oid ; scp -r build-oracc.museum.upenn.edu:/home/oracc/oid/* .)
serve-install.sh ogsl build-oracc.museum.upenn.edu
serve-install.sh ogsl/signlist build-oracc.museum.upenn.edu
serve-index.sh ogsl build-oracc.museum.upenn.edu
serve-index.sh ogsl/signlist build-oracc.museum.upenn.edu
chmod -w 00lib/ogsl.asl
if [ -d /Users ]; then
    cd 02www
    sudo chmod -R o+r *
fi
