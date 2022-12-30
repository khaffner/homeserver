# Homeserver

This repo acts mostly as documentation, backup and examples for myself. Changes here do not automatically deploy.

The power meter is entirely based on https://github.com/ned-kelly/docker-lechacal-homeassistant

## Notes:
To upgrade and restart everything, run
```console
cd code/homeserver && git pull && docker-compose pull &&  docker-compose up -d --build --force-recreate --remove-orphans && cd ~
```

To start power meter on the pi zero, run:
```console
cd docker-lechacal-homeassistant && docker-compose up -d
```
[Docs for powermeter](http://lechacal.com/wiki/index.php?title=RPICT3V1)