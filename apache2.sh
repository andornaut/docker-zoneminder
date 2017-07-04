#!/bin/bash

set -ex

exec apache2ctl -D FOREGROUND
