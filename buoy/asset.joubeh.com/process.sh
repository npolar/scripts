#!/bin/bash

# Script to parse assets downloaded via joubeh web interface.
# One file per buoy, with buoy name in filename.
#
INCLUDE='DATA DATE (UTC),LATITUDE,LONGITUDE,SST,BP,BPT,title,links,collection,IMEI'
KEYMAP='{"DATA DATE (UTC)": "measured", "LATITUDE": "latitude", "LONGITUDE": "longitude", "SST": "sea_surface_temperature", "BP": "air_pressure", "BPT": "air_pressure_tendency"}'
UUIDKEYS='measured,latitude,longitude'
NAMEPATTERN='{"pattern":".*/(.*)-\\d+.*","output":{"title":"%1"}}'
MERGE='{"collection": "buoy", "schema": "http://api.npolar.no/schema/oceanography_point-1.0.1", "links": [{"title": "Deployment logs", "rel": "log", "href": "http://data.npolar.no/raw/buoy/deployment-logs/"}]}'
JS='mapper.js'
OUT="" #"-a $NPOLAR_API_COUCHDB/oceanography_buoy" #"-o /home/anders/tmp/data.joubeh.com/"
LEVEL="" #"--quiet"
SCHEMA='http://api.npolar.no/schema/oceanography_point-1.0.1'

DATA=(/mnt/datasets/oceanography/buoy/asset.joubeh.com/**/*.csv)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-keys "$UUIDKEYS" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" $LEVEL $OUT csv ${DATA[@]}
