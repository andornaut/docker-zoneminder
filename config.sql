UPDATE Config SET Value = "/tmp/zoneminder-tmpfs"  WHERE name = "ZM_PATH_MAP";
UPDATE Config SET Value = "flat" WHERE Name = "ZM_CSS_DEFAULT";
UPDATE Config SET Value = 1 WHERE Name = "ZM_OPT_CONTROL";
UPDATE Config SET Value = "none" WHERE Name = "ZM_AUTH_RELAY";
UPDATE Config SET Value = "/cgi-bin/nph-zms"  WHERE Name = "ZM_PATH_ZMS";
UPDATE Config SET Value = "desc"  WHERE Name = "ZM_WEB_EVENT_SORT_ORDER";
UPDATE Config SET Value = 100  WHERE Name = "ZM_WEB_EVENTS_PER_PAGE";
UPDATE Config SET Value = -2  WHERE Name = "ZM_LOG_LEVEL_SYSLOG";
UPDATE Config SET Value = -2  WHERE Name = "ZM_LOG_LEVEL_DATABASE";
UPDATE Config SET Value = "2 day" WHERE Name = "ZM_LOG_DATABASE_LIMIT";
UPDATE Config SET Value = 0  WHERE Name = "ZM_RECORD_EVENT_STATS";
UPDATE Config SET Value = "1.1"  WHERE Name = "ZM_HTTP_VERSION";

UPDATE Controls SET MaxPanRange = 45, MaxPanStep = 45, MaxTiltRange = 10, HasTiltSpeed = 1, MaxTiltStep = 10, MaxTiltSpeed = 4, HasPresets = 0 WHERE Name = "Foscam 9831W";

INSERT INTO Filters VALUES ('PurgeAfterFourWeeks','{\"terms\":[{\"attr\":\"Archived\",\"op\":\"=\",\"val\":\"0\"},{\"cnj\":\"and\",\"attr\":\"Date\",\"op\":\"<\",\"val\":\"-4 week\"}],\"sort_field\":\"DateTime\",\"sort_asc\":\"1\",\"limit\":\"10000\"}',0,0,0,0,0,0,NULL,1,1);

INSERT INTO MonitorPresets VALUES (NULL,'Foscam FI9803PV2 FFMPEG H.264','Ffmpeg','/dev/video<?>','0',255,'rtsp','rtpRtsp','<username>:<pwd>@<ip-address>','443','rtsp://<username>:<pwd>@<ip-address>:443/videoMain','',1280,720,0,0.00,0,'0','','',100,100);
INSERT INTO MonitorPresets VALUES (NULL,'Foscam FI9831PV2 FFMPEG H.264','Ffmpeg','/dev/video<?>','0',255,'rtsp','rtpRtsp','<username>:<pwd>@<ip-address>','443','rtsp://<username>:<pwd>@<ip-address>:443/videoMain','',1280,720,0,0.00,1,'19','usr=<username>&pwd=<pwd>','<ip-address>:443',100,100);
