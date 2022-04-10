# Homeserver

This repo acts mostly as documentation and examples for myself, changes here do not automatically deploy on my server.

## Notes:
To upgrade and restart home assistant, run
```console
cd code/homeserver && git pull && docker-compose up -d --build --force-recreate --remove-orphans home-assistant
```

To start power meter on the pi zero, run:
```console
stty -echo -F /dev/ttyAMA0 raw speed 38400 && cd homeserver && git pull && docker-compose -f docker-compose.powermeter.yml up -d --build