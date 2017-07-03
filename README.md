# docker-zoneminder

## Usage

```
# Restart apache from outside the container
docker exec -ti $(docker ps|grep docker-zoneminder|awk '{print $1}') apache2ctl restart
```
