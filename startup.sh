#!/bin/bash

cd /opt/azkaban/azkaban-solo-server
bin/start-solo.sh
sleep 1
exec tail -f local/azkaban-webserver.log
