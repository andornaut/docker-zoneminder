UPDATE Config SET Value = "none" WHERE Name = "ZM_AUTH_RELAY";
UPDATE Config SET Value = 0 WHERE Name = "ZM_CHECK_FOR_UPDATES";
UPDATE Config SET Value = "/zm/" WHERE Name = "ZM_HOME_URL";
UPDATE Config SET Value = "1.1"  WHERE Name = "ZM_HTTP_VERSION";
UPDATE Config SET Value = "en_us" WHERE Name = "ZM_LANG_DEFAULT";
UPDATE Config SET Value = 1 WHERE Name = "ZM_OPT_CONTROL";
UPDATE Config SET Value = 0 WHERE Name = "ZM_RECORD_EVENT_STATS";
UPDATE Config SET Value = 0 WHERE Name = "ZM_SHOW_PRIVACY";
UPDATE Config SET Value = 0 WHERE Name = "ZM_TELEMETRY_DATA";
UPDATE Config SET Value = "http://localhost" WHERE Name = "ZM_TELEMETRY_SERVER_ENDPOINT";
UPDATE Config SET Value = "America/Toronto" WHERE Name = "ZM_TIMEZONE";

UPDATE Config SET Value = -1  WHERE Name = "ZM_LOG_LEVEL_DATABASE";
UPDATE Config SET Value = -1  WHERE Name = "ZM_LOG_LEVEL_FILE";
UPDATE Config SET Value = -5  WHERE Name = "ZM_LOG_LEVEL_SYSLOG";
UPDATE Config SET Value = -5  WHERE Name = "ZM_LOG_LEVEL_WEBLOG";
UPDATE Config SET Value = "3 day" WHERE Name = "ZM_LOG_DATABASE_LIMIT";
UPDATE Config SET Value = 0 WHERE Name = "ZM_LOG_FFMPEG";

UPDATE Config SET Value = "desc"  WHERE Name = "ZM_WEB_EVENT_SORT_ORDER";
UPDATE Config SET Value = 100  WHERE Name = "ZM_WEB_EVENTS_PER_PAGE";
UPDATE Config Set Value = 0 WHERE Name = "ZM_WEB_POPUP_ON_ALARM";
UPDATE Config Set Value = 0 WHERE Name = "ZM_WEB_RESIZE_CONSOLE";

UPDATE Controls SET MaxPanRange = 45, MaxPanStep = 45, MaxTiltRange = 10, HasTiltSpeed = 1, MaxTiltStep = 10, MaxTiltSpeed = 4, HasPresets = 0 WHERE Name = "Foscam 9831W";

INSERT INTO Filters VALUES (NULL, 'PurgeAfterFourWeeks','{\"terms\":[{\"attr\":\"Archived\",\"op\":\"=\",\"val\":\"0\"},{\"cnj\":\"and\",\"attr\":\"StartDate\",\"op\":\"<\",\"val\":\"-4 week\"}],\"sort_field\":\"StartDateTime\",\"sort_asc\":\"1\",\"limit\":\"10000\"}',0,0,0,0,0,0,'0',1,0,0,0,0,0,1,0);
INSERT INTO MonitorPresets VALUES (NULL,'Amcrest IP4M-1025E FFMPEG H.264','Ffmpeg','/dev/video<?>','0',255,'rtsp','rtpRtsp','<username>:<pwd>@<ip-address>','443','rtsp://<username>:<pwd>@<ip-address>:554/cam/realmonitor?channel=1&subtype=0','',1280,720,0,0.00,0,'0','','',100,100);
INSERT INTO MonitorPresets VALUES (NULL,'Foscam FI9831PV2 FFMPEG H.264','Ffmpeg','/dev/video<?>','0',255,'rtsp','rtpRtsp','<username>:<pwd>@<ip-address>','443','rtsp://<username>:<pwd>@<ip-address>:443/videoMain','',1280,720,0,0.00,1,'19','usr=<username>&pwd=<pwd>','<ip-address>:443',100,100);
