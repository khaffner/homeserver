#!/bin/bash
while true
do
    # Get data from sensor. Some times, the data is incomplete.
    data=$(head -n 1 /dev/ttyAMA0)

    echo $data

    # If valid reading, make into json
    data="${data// /;}"
    json=$(jq -c --null-input --arg data "$data" '{"state":$data}')

    # Send the data to Home Assistant
    curl -X POST \
        -H "Authorization: Bearer ${HATOKEN}" \
        -H "Content-Type: application/json" \
        http://192.168.1.2:8123/api/states/sensor.powermeterraw \
        -d $json \
        -s \
        -o /dev/null

    sleep 4
done