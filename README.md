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
docker-compose exec zoneminder mysql -e 'TRUNCATE Logs' zm
```

## Configuration

You can run the [settings.sql](settings.sql) to update some ZoneMinder settings.

```bash
docker-compose exec zoneminder sh -c 'cat settings.sql|mysql zm'
```

Execute the following SQL in the MySQL database running in the container to add monitor presets for:
 
* Amcrest IP4M-1025E
* Foscam FI9831PV2

```sql
INSERT INTO MonitorPresets VALUES (NULL,'Amcrest IP4M-1025E FFMPEG H.264','Ffmpeg','/dev/video<?>','0',255,'rtsp','rtpRtsp','<username>:<pwd>@<ip-address>','443','rtsp://<username>:<pwd>@<ip-address>:554/cam/realmonitor?channel=1&subtype=0','',1280,720,0,0.00,0,'0','','',100,100);
INSERT INTO MonitorPresets VALUES (NULL,'Foscam FI9831PV2 FFMPEG H.264','Ffmpeg','/dev/video<?>','0',255,'rtsp','rtpRtsp','<username>:<pwd>@<ip-address>','443','rtsp://<username>:<pwd>@<ip-address>:443/videoMain','',1280,720,0,0.00,1,'19','usr=<username>&pwd=<pwd>','<ip-address>:443',100,100);
```

## Links

- [ansible-role-zoneminder](https://github.com/andornaut/ansible-role-zoneminder)
- [Docker Hub image](https://hub.docker.com/r/andornaut/zoneminder/)
- [Official ZoneMinder Dockerfiles](https://github.com/ZoneMinder/zmdockerfiles)
