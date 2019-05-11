#!/bin/sh
(cd ~/orc/oid ; scp -r build:/home/oracc/oid/* .)
serve-install.sh ogsl build-oracc.museum.upenn.edu
serve-install.sh ogsl/signlist build-oracc.museum.upenn.edu
serve-index.sh ogsl build-oracc.museum.upenn.edu
serve-index.sh ogsl/signlist build-oracc.museum.upenn.edu
