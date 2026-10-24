#!/usr/bin/env bash

set -e
set -E

app_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

source "${app_root}/grindle.sh"

g_root_err_trap

main() {
	local arg_cfg_file_path="${1}"
	local arg_command="${2}"

	if [[ -z "${arg_command}" ]]; then
		g_err "A command must be provided i.e. 'app-popover.sh launch'."

		exit 1
	fi

	if [[ ! "${arg_command}" =~ ^(show|hide|toggle|launch)$ ]]; then
		g_err "Invalid command provided: '${arg_command}'."

		exit 1
	fi

	if [[ ! -f "${arg_cfg_file_path}" ]]; then
		g_err "Invalid config file path provided: '${arg_cfg_file_path}'."

		exit 1 
	fi

	source "${arg_cfg_file_path}"
	g_import "utl-user, utl-internal, cmd-${arg_command}" from "${app_root}"
	g_expect 'g_is_fn "cmd_run"'

	cmd_run
}; g_iife main "${@}"
