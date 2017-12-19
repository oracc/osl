#!/bin/sh
sl-xml.plx ogsl
sl-db.plx ogsl
oracc web
pubfiles.sh ogsl
cd 02pub ; ln -sf ogsl-db.dir ogsl-db
# These links must be made by the oracc user from the ogsl
# public versions.
#ln -s ${ORACC}/pub/ogsl/ogsl-db ${ORACC}/xml/ogsl/ogsl.xml \
#    ${ORACC}/lib/data
