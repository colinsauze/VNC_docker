#!/bin/bash

cd


pwgen -1 > /tmp/passwd

bash /opt/set_password.sh `cat /tmp/passwd`

vncserver -geometry 1024x768

vnc_port=5901

web_port=8000

echo -n "password is "
cat /tmp/passwd
#/opt/noVNC-1.0.0/utils/launch.sh --vnc localhost:$vnc_port --listen $web_port --cert /opt/server.cert

#non-SSL version
/opt/noVNC-1.0.0/utils/launch.sh --vnc localhost:$vnc_port --listen $web_port

