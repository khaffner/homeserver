while true; do
    # Read the line from serial port
    LINE=$(head -n 1 /dev/ttyAMA0)

    # Replace spaces with underscores
    LINE="${LINE// /_}"

    # Print the line for loggings sake
    echo $LINE

    # Publish value to mqtt server
    mosquitto_pub -h 192.168.1.8 -t powermeter -m $LINE -u $MQTTUSER -P $MQTTPASS
done
