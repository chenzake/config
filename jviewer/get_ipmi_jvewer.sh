#!/bin/sh
set -x
set -e
USER=root
PASS=admin
HOST=192.168.87.12

COOKIE=`curl --data "WEBVAR_USERNAME=$USER&WEBVAR_PASSWORD=$PASS" http://$HOST/rpc/WEBSES/create.asp 2> /dev/null | grep SESSION_COOKIE | cut -d\' -f 4`

echo $COOKIE
curl --cookie Cookie=SessionCookie=$COOKIE http://$HOST/Java/jviewer.jnlp -o $HOST.jviewer2.jnlp
