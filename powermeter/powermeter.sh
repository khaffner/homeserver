#!/bin/bash
while true
do
    data=$(head -n 1 /dev/ttyAMA0)
    data="${data// /;}"
    json=$(jq -c --null-input --arg data "$data" '{"state":$data}')

    curl -X POST \
        -H "Authorization: Bearer ${HATOKEN}" \
        -H "Content-Type: application/json" \
        http://192.168.1.2:8123/api/states/sensor.powermeterraw \
        -d $json

    sleep 4
done