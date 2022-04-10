#!/bin/bash
while true
do
    # Get data from sensor. Some times, the data is incomplete.
    data=$(head -n 1 /dev/ttyAMA0)

    # Valid readings start with a 1
    if [[ $data == 1* ]] ;
    then
        # If valid reading, make into json
        data="${data// /;}"
        json=$(jq -c --null-input --arg data "$data" '{"state":$data}')

        # Echo the json for logging purposes
        echo $json

        # Send the data to Home Assistant
        curl -X POST \
            -H "Authorization: Bearer ${HATOKEN}" \
            -H "Content-Type: application/json" \
            http://192.168.1.2:8123/api/states/sensor.powermeterraw \
            -d $json
    else
        # If reading does not start with 1, only output it to host.
        echo "Invalid data: $data"
    fi

    sleep 1
done