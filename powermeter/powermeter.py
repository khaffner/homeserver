 #!/usr/bin/python3

 # http://lechacal.com/wiki/index.php/Raspberrypi_Current_and_Temperature_Sensor_Adaptor#Using_Python_basic_script

import serial
import json
import os
import time
from requests import post

ser = serial.Serial('/dev/ttyAMA0', 38400)

token = os.environ.get('HATOKEN')
url = 'http://192.168.1.2:8123/api/states/sensor.watts'
headers = {
            'Authorization': f"Bearer {token}",
            'content-type': 'application/json',
        }

try:
    while 1:
        response = str(ser.readline())

        # Valid readings seem to start with b
        if response.startswith('b'):
            # response might look like this:
            # b'4 0.245 11 491.34 572.0258 2.05 9.94 0.0260.57 011 489.412.14 0.60.96 0.11 501.11 580.2619.15 0..000\r\n'
            # The interesting part is right after "11 ", and I don't need decimals.
            watts = response.split('11 ')[1].split('.')[0]

            print(watts)

            data = {
                "state": watts
            }

            response = post(url, headers=headers, data=json.dumps(data))
        else: 
            print(f"Invalid response: {response}")

        time.sleep(4)
except KeyboardInterrupt:
    ser.close()