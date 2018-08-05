# docker-zoneminder

Dockerized [ZoneMinder](https://github.com/ZoneMinder/ZoneMinder) video surveillance software system.

Note that [this Docker image](https://hub.docker.com/r/andornaut/zoneminder/) includes Apache2 and MySQL in addition
to ZoneMinder itself. Running multiple services in the same Docker container is not generally advisable, but this
project does so nevertheless out of pragmatic desire for an all-in-one solution.

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

# Clear logs
docker exec zoneminder mysql -e 'TRUNCATE Logs' zm
```

## Configuration

Default configuration is specified in the [config.sql](./config.sql) file. This script changes some defaults settings,
and adds monitor presets:

- Foscam FI9803PV2
- Foscam FI9831PV2
- Amcrest IP4M-1025E

## Links

- [ansible-role-zoneminder](https://github.com/andornaut/ansible-role-zoneminder)
- [Docker Hub image](https://hub.docker.com/r/andornaut/zoneminder/)
