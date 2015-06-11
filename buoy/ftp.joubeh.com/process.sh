#!/bin/bash

# Joubeh csv is one directory per day. This parser will always parse today and yesterday.
# The ids are generated on the same set of keys each run and couchdb will reject
# documents with ids thats allready in the database.
#
INCLUDE='Data Date(GMT),LATITUDE,LONGITUDE,SST,BP,BPT,title,links,collection,IMEI'
KEYMAP='{"Data Date(GMT)": "measured", "LATITUDE": "latitude", "LONGITUDE": "longitude", "SST": "sea_surface_temperature", "BP": "air_pressure", "BPT": "air_pressure_tendency"}'
UUIDKEYS='measured,latitude,longitude'
NAMEPATTERN='{"pattern":".*/(\\d{15}).*","output":{"IMEI": "%1"}}'
MERGE='{"collection": "buoy", "schema": "http://api.npolar.no/schema/oceanography_point-1.0.1", "links": [{"title": "Deployment logs", "rel": "log", "href": "http://data.npolar.no/raw/buoy/deployment-logs/"}]}'
JS='mapper.js'
OUT="-a $NPOLAR_API_COUCHDB/oceanography_buoy" #"-o /home/anders/tmp/data.joubeh.com/"
LEVEL="INFO"
MAIL="balter@npolar.no"
LOGFILE="/home/external/logs/ghostdoc-joubeh.log"
SCHEMA="http://api.npolar.no/schema/oceanography_point-1.0.1"

TODAY=`date +%F`
YESTERDAY=`date +%F --date='yesterday'`

DATA=(/mnt/datasets/oceanography/buoy/ftp.joubeh.com/*/{$YESTERDAY,$TODAY}/{300234062442640,300234062447650,300234062726310,300234062317630,300234062722280,300234061371430,300234061369140,300234062311650,300234062426150,300234062426060,300234011090780,300234010080470,300234010084440,300234011091510}*.csv)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-keys "$UUIDKEYS" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" --log-level "$LEVEL" --log-mail "$MAIL" --log-file "$LOGFILE" $OUT csv ${DATA[@]}
