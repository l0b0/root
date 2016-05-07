#!/bin/sh

set -o errexit -o xtrace

port='9999'
log='netcat.log'
expected_value='foo'
netcat="$(which nc.traditional netcat | head --lines=1)"

trap 'kill $server_pid $client_pid' EXIT

"$netcat" -l -p "$port" > "$log" &
server_pid=$!

startup_timeout="$(date --date='5 seconds' +%s)"
while [ "$(date +%s)" -le "$startup_timeout" ]
do
    if "$netcat" 127.0.0.1 "$port" < /dev/null
    then
        break
    fi
    sleep 1
done

printf '%s' "$expected_value" | "$netcat" 127.0.0.1 "$port" &
client_pid=$!

timeout="$(date --date='10 seconds' +%s)"
while [ "$(date +%s)" -le "$timeout" ]
do
    if [ "$(cat "$log")" = "$expected_value" ]
    then
        exit 0
    fi
    sleep 1
done
exit 99
