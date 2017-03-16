#!/bin/bash
# WARNING: The script only applies to EdgeRouter OS
export PATH="/sbin:$PATH"
export REMOTE_ADDRESS="$1"

current_ip_exist_table=$(ip rule | grep "$REMOTE_ADDRESS" | awk '{print $5}')

if [ -z "$current_ip_exist_table" ]; then
	echo "$REMOTE_ADDRESS, No rule selected. Packet will be forwarded by default rule."
else
	echo "$REMOTE_ADDRESS gateway is $current_ip_exist_table"
fi
