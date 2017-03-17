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
	echo "$(ip rule | grep "$REMOTE_ADDRESS" | awk '{print $5}')"
}

query_current_rule_name() {
	local rule="$(query_current_rule)"
	if [ -n "$rule" ]; then
		echo "${table_mapping[$rule]}"
	fi
}

show_report() {
	local IFS=$'\n'
	local reports="$(ip rule | grep '10.' | cut -d':' -f2 | cut -d' ' -f2-)"
	for report in $reports; do
		local name="$(echo $report | cut -d' ' -f3)"
		report="${report/lookup ${name}/lookup \"${table_mapping[$name]}\"}"
		report="${report/lookup/->}"
		echo "$report"
	done
}
