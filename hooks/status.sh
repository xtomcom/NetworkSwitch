#!/bin/bash
# WARNING: The script only applies to EdgeRouter OS
source ./hooks/functions.sh

current_status="$(query_current_rule_name)"

if [ -z "$current_status" ]; then
	echo "$REMOTE_ADDRESS No Gateway."
	echo "Packet will be forwarded by default rule."
else
	echo "$REMOTE_ADDRESS Gateway is \"$current_status\""
fi
