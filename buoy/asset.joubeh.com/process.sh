#!/bin/bash

# Script to parse assets downloaded via joubeh web interface.
# One file per buoy, with buoy name in filename.
#
INCLUDE='DATA DATE (UTC),LATITUDE,LONGITUDE,SST,BP,BPT,title,links,collection'
KEYMAP='{"DATA DATE (UTC)": "measured", "LATITUDE": "latitude", "LONGITUDE": "longitude", "SST": "sea_surface_temperature", "BP": "air_pressure", "BPT": "air_pressure_tendency"}'
UUIDKEYS='measured,latitude,longitude'
NAMEPATTERN='{"pattern":".*/(.*)-\\d+.*","output":{"links": [
  {"title": "Temperature data", "href": "http://api.npolar.no/buoy/td?filter-buoy=%1"},
  {"title": "Status data", "href": "http://api.npolar.no/buoy/st?filter-buoy=%1"}],
  "title": "%1"}}'
MERGE='{"collection": "buoy", "schema": "http://api.npolar.no/schema/oceanography_point-1.0.0"}'
JS='mapper.js'
OUT="" #"-o /home/anders/tmp/data.joubeh.com/"
LEVEL="" #"--quiet"
SCHEMA='http://api.npolar.no/schema/oceanography_point-1.0.0'

DATA=(/mnt/datasets/oceanography/buoy/asset.joubeh.com/**/*.csv)

ghostdoc --include "$INCLUDE" --key-map "$KEYMAP" --uuid-keys "$UUIDKEYS" --name-pattern "$NAMEPATTERN" --merge "$MERGE" --js "$JS" --schema "$SCHEMA" $LEVEL $OUT csv ${DATA[@]} #&
