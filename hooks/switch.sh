#!/bin/bash
# WARNING: The script only applies to EdgeRouter OS
source ./hooks/functions.sh

if [ "$MODE_NAME" == "clear_settings" ]; then
	ip rule del from "$REMOTE_ADDRESS"
	echo "$REMOTE_ADDRESS Rule Cleared."
	exit
elif [ "$MODE_NAME" == "$(query_current_rule)" ]; then
	echo "$REMOTE_ADDRESS Current Rule is \"$(query_current_rule_name)\""
	exit
else
	ip rule del from "$REMOTE_ADDRESS"
	ip rule add from "$REMOTE_ADDRESS" table "$MODE_NAME"

	if [ -n "$(query_current_rule)" ]; then
		echo "Success! $REMOTE_ADDRESS Now Gateway is \"$(query_current_rule_name)\""
	else
		echo "Failed! $REMOTE_ADDRESS"
	fi
	exit
fi
