# docker-zoneminder

Dockerized [ZoneMinder](https://github.com/ZoneMinder/ZoneMinder) video surveillance software system.

This image is published to Docker Hub as [andornaut/zoneminder](https://hub.docker.com/r/andornaut/zoneminder/).

Like the [official Dockerfiles](https://github.com/ZoneMinder/zmdockerfiles),
this image includes Apache2 and MySQL in addition to ZoneMinder itself.
Running multiple services in the same Docker container is not generally advisable, but this
project does so nevertheless out of pragmatic desire for an all-in-one solution.

## Usage

```
# Start
docker-compose up --build
google-chrome http://localhost:8080

# Get status
docker-compose exec zoneminder zmdc.pl status

# Publish to hub.docker.com
docker login
docker-compose build
docker-compose push

# Clear logs
docker exec zoneminder mysql -e 'TRUNCATE Logs' zm
```

## Configuration

The MySQL "zm" database is updated when it is initialized for the first time via [init.sql](./init.sql).

This SQL script changes some defaults settings and adds some monitor presets:

- Foscam FI9803PV2
- Foscam FI9831PV2
- Amcrest IP4M-1025E

## Links

- [ansible-role-zoneminder](https://github.com/andornaut/ansible-role-zoneminder)
- [Docker Hub image](https://hub.docker.com/r/andornaut/zoneminder/)
- [Official ZoneMinder Dockerfiles](https://github.com/ZoneMinder/zmdockerfiles)
