#!/bin/bash
#read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
#trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

exec apache2ctl -D FOREGROUND >>/var/log/apache2.log 2>&1
