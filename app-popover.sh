#!/usr/bin/env bash

set -e
set -E

app_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "${app_root}/grindle.sh"

trap "g_err \"An error occured during execution.\"" ERR

main() {
	local arg_command="${1}"

	if [[ -z "${arg_command}" ]]; then
		g_err "A command must be provided i.e. 'app-popover.sh launch'."

		exit 1
	fi

	if [[ ! "${arg_command}" =~ ^(show|hide|toggle|launch)$ ]]; then
		g_err "Invalid command provided: '${arg_command}'."

		exit 1
	fi

	g_import "cfg, utl-user, utl-internal" from "${app_root}"
	g_import "cmd-${arg_command}" from "${app_root}"
	g_expect 'g_is_fn "run_command"'

	run_command
}; g_iife main "${1}"
