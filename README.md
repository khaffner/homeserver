# Homeserver

This repo acts mostly as documentation, backup and examples for myself. Changes here do not automatically deploy.

## Notes:
To upgrade and restart home assistant, run
```console
cd code/homeserver && git pull && docker-compose up -d --build --force-recreate --remove-orphans home-assistant
```

To start power meter on the pi zero, run:
```console
stty -echo -F /dev/ttyAMA0 raw speed 38400 && cd homeserver && git pull && docker-compose -f docker-compose.powermeter.yml up -d --build
```
[Docs for powermeter](http://lechacal.com/wiki/index.php/Raspberrypi_Current_and_Temperature_Sensor_Adaptor#Using_plain_Linux_terminal_-_CAT_command)