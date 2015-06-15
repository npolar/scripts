#!/bin/bash

# martech.sams.ac.uk use one text file per buoy which they append data to.
# This parser will parse and post all data from each file on each run,
# regardless if the data is allready in the database.
# The ids are generated on the same set of keys each run and couchdb will reject
# documents with ids thats allready in the database.

export PATH=$PATH:$HOME/bin
DIRNAME="$(dirname $(readlink -f $0))"
INCLUDE='GPSDateTime,GPSLat,GPSLng,title,links,collection,IMEI'
KEYMAP='{"GPSDateTime": "measured", "GPSLat": "latitude", "GPSLng": "longitude"}'
UUIDINCLUDE='measured,latitude,longitude'
NAMEPATTERN='{"pattern":".*/(.*_\\d{2}).*","output":{"title": "%1"}}'
MERGE_COMMON='"collection": "buoy", "schema": "http://api.npolar.no/schema/oceanography_point-1.0.1"'
JS="$DIRNAME/mapper.js"
OUT="-a $NPOLAR_API_COUCHDB/oceanography_buoy" #"-o /home/anders/tmp/martech.sams.ac.uk/"
LEVEL="INFO"
MAIL="balter@npolar.no"
LOGFILE="$HOME/logs/ghostdoc-sams.log"
SCHEMA="http://api.npolar.no/schema/oceanography_point-1.0.1"

# FMI
HEADER='/mnt/datasets/oceanography/buoy/martech.sams.ac.uk/fmi/headers/gps.txt'
LINKS='"links": [{"title": "Deployment logs", "rel": "log", "href": "http://data.npolar.no/raw/buoy/deployment-logs/"}]'
MERGE="{$MERGE_COMMON, $LINKS}"
DATA=(/mnt/datasets/oceanography/buoy/martech.sams.ac.uk/fmi/FMI_{14,19,20}_gps.txt)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-include "$UUIDINCLUDE" --uuid-key "_id" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" --log-level "$LEVEL" --log-mail "$MAIL" --log-file "$LOGFILE" $OUT csv --header $HEADER ${DATA[@]}

# NPOL
HEADER='/mnt/datasets/oceanography/buoy/martech.sams.ac.uk/npol/headers/gps.txt'
LINKS='"links": [{"title": "Deployment logs", "rel": "log", "href": "http://data.npolar.no/raw/buoy/deployment-logs/"}]'
MERGE="{$MERGE_COMMON, $LINKS}"
DATA=(/mnt/datasets/oceanography/buoy/martech.sams.ac.uk/npol/NPOL_{01,03,04,05}_gps.txt)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-include "$UUIDINCLUDE" --uuid-key "_id" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" --log-level "$LEVEL" --log-mail "$MAIL" --log-file "$LOGFILE" $OUT csv --header $HEADER ${DATA[@]}
