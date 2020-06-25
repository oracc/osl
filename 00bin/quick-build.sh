#!/bin/sh
git pull
sl-xml.plx ogsl ; sl-db.plx ogsl ; sl-index -boot
