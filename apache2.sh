#!/bin/bash

set -e

exec apache2ctl -D FOREGROUND 2>&1
