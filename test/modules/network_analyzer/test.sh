#!/usr/bin/env bash

vm_command <<'EOF'
set -o errexit -o nounset -o xtrace

port='9999'
log='netcat.log'
expected_value='foo'

trap 'kill $server_pid $client_pid' EXIT

netcat -l -p "$port" > "$log" &
server_pid=$!

printf '%s' "$expected_value" | netcat --wait=1 127.0.0.1 "$port" &
client_pid=$!

timeout="$(date --date='3 seconds' +%s)"
while [ "$(date +%s)" -le "$timeout" ]
do
    if [ "$(cat "$log")" = "$expected_value" ]
    then
        exit 0
    fi
    sleep 1
done
exit 99
EOF
