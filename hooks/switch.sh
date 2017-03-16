#!/bin/bash
# WARNING: The script only applies to EdgeRouter OS
export PATH="/sbin:$PATH"
export REMOTE_ADDRESS="$1"
export MODE_NAME="$2"

exist_rule=$(ip rule | grep "$REMOTE_ADDRESS")

if [ -n "$exist_rule" ] || [ "$MODE_NAME" == "clear_settings" ]; then
	ip rule del from "$REMOTE_ADDRESS"
fi

if [ "$MODE_NAME" == "clear_settings" ]; then
	echo "$REMOTE_ADDRESS rule cleared."
	exit
fi

ip rule add from "$REMOTE_ADDRESS" table "$MODE_NAME"

exist_rule=$(ip rule | grep "$REMOTE_ADDRESS")

if [ -n "$exist_rule" ]; then
	echo "Success! $REMOTE_ADDRESS now Gateway is $MODE_NAME"
else
	echo "Failed!"
fi
