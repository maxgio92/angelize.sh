#! /usr/bin/env bash

set -eu

function show_help() {
    printf "Usage:\nangelize.sh -p [daemon pidfile path] -c [daemon command]\n"
}

# Proxy signals
function kill_app() {
    kill $(cat $pidfile)
    exit 0 # exit okay
}

pidfile=
command=

while getopts "h?:p:c:" opt; do
    case "$opt" in
    p)
        pidfile=$OPTARG

        if [[ $OPTARG = -* ]]; then
            ((OPTIND--));
            pidfile=;
        fi
        ;;
    c)
        command=$OPTARG

        if [[ $OPTARG = -* ]]; then
            ((OPTIND--));
            command=;
        fi
        ;;
    h|\?)
        show_help;
        exit 0
        ;;
    *|:)
        show_help;
        exit 1
        ;;
    esac 
done

if [[ -z $@ ]]; then
    show_help;
    exit 1;
fi

if [ -z "$pidfile" ]; then
    echo "Daemon pidfile path argument is required";
    show_help;
    exit 1;
elif [ ! -f "$pidfile" ]; then
    echo "Daemon pidfile does not exists";
    exit 1;
fi

if [ -z "$command" ]; then
    echo "Daemon command argument is required";
    show_help;
    exit 1;
fi

trap "kill_app" SIGINT SIGTERM

# Launch" daemon
$command
sleep 2

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
    sleep 0.5
done

exit 1000 # exit unexpected
