#!/bin/sh
grep ^LAK /home/oracc/osl/02pub/lists.tsv | tail -n +2 | sort -u >list-lak.tsv
./lak-xml.plx >lak.xml
xsltproc x2h.xsl lak.xml >lak.html
sudo cp lak.html lakproof.css /home/oracc/osl/02www
sudo chmod o+r /home/oracc/osl/02www/lak.html /home/oracc/osl/02www/lakproof.css
