#!/bin/bash

set -e
set -x
function cleanup {
    # Remove JNLP file and SSH process
    rm -f $HOST.jviewer.jnlp
    kill $!
}

USAGE="Usage: $0 -p <SSH proxy host> <hostname> <username>"

while getopts ":p:" opt; do
    case $opt in
        p)
            PROXY_HOST=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 2
            ;;
    esac
done

shift $((OPTIND-1))

if [ $# -ne 2 ]; then
    echo $USAGE
    exit 2
fi

HOST=$1
USER=$2
read -p "Password for $2@$1: " -s PASS

#trap cleanup EXIT

if [ -z "$PROXY_HOST" ]; then
    FRONTEND_HOST=$HOST
    PORT=80
else
    FRONTEND_HOST=192.168.86.200
    PORT=8080
    #ssh -o ExitOnForwardFailure=yes -g -L $PORT:$HOST:80 -g -L 7578:$HOST:7578 $PROXY_HOST sleep 100000 &
    ssh -o ExitOnForwardFailure=yes -g -L $PORT:$HOST:80 -g -L 8081:$HOST:7578 $PROXY_HOST sleep 100000 &
    sleep 1
fi

SESSION_URL="http://$FRONTEND_HOST:$PORT/rpc/WEBSES/create.asp"
JVIEWER_URL="http://$FRONTEND_HOST:$PORT/Java/jviewer.jnlp"

POST_MSG="WEBVAR_USERNAME=$USER&WEBVAR_PASSWORD=$PASS"
COOKIE=`curl -# --data $POST_MSG $SESSION_URL 2> /dev/null | grep SESSION_COOKIE | cut -d\' -f 4`

curl -# --cookie Cookie=SessionCookie=$COOKIE $JVIEWER_URL -o $HOST.jviewer.jnlp

echo "Did you know: You can connect to http://$FRONTEND_HOST:$PORT for the web console"
#javaws -wait $HOST.jviewer.jnlp
javaws  $HOST.jviewer.jnlp
