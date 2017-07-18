# docker-zoneminder

Dockerized video surveillance software system.

## Usage

```
# Start
docker-compose up --build
google-chrome http://localhost:8080

# Get status
docker exec zoneminder zmdc.pl status

# Publish to hub.docker.com
docker login
docker-compose build
docker-compose push
```

## Configuration

Default configuration is specified in the [config.sql](./config.sql) file. This file sets some custom defaults and
also includes some additional monitor presets:

* Foscam FI9803PV2 FFMPEG H.264
* Foscam FI9831PV2 FFMPEG H.264
