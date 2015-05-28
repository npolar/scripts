#!/bin/bash

# Joubeh csv is one directory per day. This parser will always parse today and yesterday.
# The ids are generated on the same set of keys each run and couchdb will reject
# documents with ids thats allready in the database.
#
INCLUDE='Data Date(GMT),LATITUDE,LONGITUDE,SST,BP,BPT,title,links,collection'
KEYMAP='{"Data Date(GMT)": "measured", "LATITUDE": "latitude", "LONGITUDE": "longitude", "SST": "sea_surface_temperature", "BP": "air_pressure", "BPT": "air_pressure_tendency"}'
UUIDKEYS='measured,latitude,longitude'
NAMEPATTERN='{"pattern":".*/(\\d{15}).*","output":{"links": [
  {"title": "Temperature data", "href": "http://api.npolar.no/buoy/td?filter-buoy=%1"},
  {"title": "Status data", "href": "http://api.npolar.no/buoy/st?filter-buoy=%1"}],
  "IMEI": "%1"}}'
MERGE='{"collection": "buoy", "schema": "http://api.npolar.no/schema/oceanography_point-1.0.0"}'
JS='mapper.js'
OUT="" #"-o /home/anders/tmp/data.joubeh.com/"
LEVEL="" #"--quiet"
SCHEMA="http://api.npolar.no/schema/oceanography_point-1.0.0"

TODAY=`date +%F`
YESTERDAY=`date +%F --date='yesterday'`

# NPI buoys
DATA=(/mnt/datasets/oceanography/buoy/ftp.joubeh.com/NPIbuoys/{$YESTERDAY,$TODAY}/{300234062442640,300234062447650,300234062726310,300234062317630,300234062722280}*.csv)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-keys "$UUIDKEYS" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" $LEVEL $OUT csv ${DATA[@]} #&

# sbuoys
DATA=(/mnt/datasets/oceanography/buoy/ftp.joubeh.com/sbuoys/{$YESTERDAY,$TODAY}/{300234061371430,300234061369140,300234062311650,300234062426150,300234062426060}*.csv)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-keys "$UUIDKEYS" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" $LEVEL $OUT csv ${DATA[@]} #&

# fmi
DATA=(/mnt/datasets/oceanography/buoy/ftp.joubeh.com/fmi/{$YESTERDAY,$TODAY}/{300234011090780,300234010080470,300234010084440,300234011091510}*.csv)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-keys "$UUIDKEYS" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" $LEVEL $OUT csv ${DATA[@]} #&
