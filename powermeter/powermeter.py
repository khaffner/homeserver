 #!/usr/bin/python3

 # http://lechacal.com/wiki/index.php/Raspberrypi_Current_and_Temperature_Sensor_Adaptor#Using_Python_basic_script

import serial
import re
import json
import os
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
        response = ser.readline()
        watts = re.search('(?<=1 )\d{2,}',response).group(1)

        print(response)
        print(watts)

        data = {
            "state": watts
        }

        response = post(url, headers=headers, data=json.dumps(data))
except KeyboardInterrupt:
    ser.close()