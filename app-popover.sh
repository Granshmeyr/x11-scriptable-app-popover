#!/usr/bin/env bash

set -e
set -E

app_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "${app_root}/grindle.sh"

trap "g_err \"An error occured during execution.\"" ERR

main() {
	local arg_command="${1}"
	APP_POPOVER=0

	if [[ -z "${arg_command}" ]]; then
		g_err "A command must be provided i.e. 'app-popover launch'."

		exit 1
	fi

	if [[ ! "${arg_command}" =~ ^(show|hide|toggle|launch)$ ]]; then
		g_err "Invalid command provided: '${arg_command}'."

		exit 1
	fi

	g_import "${arg_command}" from "${app_root}"
}; g_iife main "${1}"
