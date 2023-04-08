# Homeserver

This repo acts mostly as documentation, backup and examples for myself. Changes here do not automatically deploy.


## Main server:
To upgrade and restart everything, run
```console
cd code/homeserver && git pull && docker-compose pull &&  docker-compose up -d --build --force-recreate --remove-orphans && cd ~
```

## Powermeter:
To configure, rename secrets.env.template to secrets.env and replace values within.

To start powermeter on the pi zero, run:
```console
cd homeserver && docker-compose -f docker-compose_powermeter.yml up -d
```
[Powermeter hardware docs](http://lechacal.com/wiki/index.php?title=RPICT3V1)