#!/bin/bash
# WARNING: The script only applies to EdgeRouter OS
export PATH="/sbin:$PATH"
export REMOTE_ADDRESS="$1"
export MODE_NAME="$2"

table_mapping=(
	[main]="Auto routes"
	[china_telecom]="China Telecom"
	[china_unicom]="China Unicom"
	[load_balance]="Load Balance"
)

query_current_rule() {
	ip rule | grep "$REMOTE_ADDRESS" | awk '{print $5}'
}

query_current_rule_name() {
	local -r mode_name="$(query_current_rule)"
	if test "${table_mapping[$mode_name]+isset}"; then
		echo "${table_mapping[$mode_name]}"
	else
		echo "$mode_name"
	fi
}

show_report() {
	local IFS=$'\n'
	local filter=$'10.'
	local -r reports=$(ip rule | grep "$filter" | cut -d' ' -f2-)
	for report in $reports; do
		remote_ip=$(echo "$report" | cut -d' ' -f1)
		mode_name=$(echo "$report" | cut -d' ' -f3)
		echo "${remote_ip} -> \"${table_mapping[$mode_name]}\""
	done
}
