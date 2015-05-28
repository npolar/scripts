#!/bin/bash

# martech.sams.ac.uk use one text file per buoy which they append data to.
# This parser will parse and post all data from each file on each run,
# regardless if the data is allready in the database.
# The ids are generated on the same set of keys each run and couchdb will reject
# documents with ids thats allready in the database.
#
INCLUDE='GPSDateTime,GPSLat,GPSLng,title,links,collection'
KEYMAP='{"GPSDateTime": "measured", "GPSLat": "latitude", "GPSLng": "longitude"}'
UUIDKEYS='measured,latitude,longitude'
NAMEPATTERN='{"pattern":".*/(.*_\\d{2}).*","output":{"links": [
  {"title": "Temperature data", "href": "http://api.npolar.no/buoy/td?filter-buoy=%1"},
  {"title": "Status data", "href": "http://api.npolar.no/buoy/st?filter-buoy=%1"}],
  "title": "%1"}}'
MERGE='{"collection": "buoy", "schema": "http://api.npolar.no/schema/oceanography_point-1.0.0"}'
JS='mapper.js'
OUT="" #"-o /home/anders/tmp/martech.sams.ac.uk/"
LEVEL="" #"--quiet"
SCHEMA="http://api.npolar.no/schema/oceanography_point-1.0.0"

# FMI
HEADER='/mnt/datasets/oceanography/buoy/martech.sams.ac.uk/fmi/headers/gps.txt'
DATA=(/mnt/datasets/oceanography/buoy/martech.sams.ac.uk/fmi/FMI_{13,14,19,20}_gps.txt)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-keys "$UUIDKEYS" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" $LEVEL $OUT csv --header $HEADER ${DATA[@]} #&

# NPOL
HEADER='/mnt/datasets/oceanography/buoy/martech.sams.ac.uk/npol/headers/gps.txt'
DATA=(/mnt/datasets/oceanography/buoy/martech.sams.ac.uk/npol/NPOL_{01,03,04,05}_gps.txt)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-keys "$UUIDKEYS" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" $LEVEL $OUT csv --header $HEADER ${DATA[@]} #&
