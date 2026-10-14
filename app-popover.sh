#!/usr/bin/env bash

set -e
set -E

app_root="${BASH_SOURCE%/*}"

source "${app_root}/grindle.sh"

trap "g_err \"An error occured during execution.\"" ERR

main() {
	local _arg_command="${1}"

	if [[ -z "${_arg_command}" ]]; then
		g_err "A command must be provided i.e. 'app-popover.sh launch'."

		exit 1
	fi

	if [[ ! "${_arg_command}" =~ ^(show|hide|toggle|launch)$ ]]; then
		g_err "Invalid command provided: '${_arg_command}'."

		exit 1
	fi

	g_import "cfg, utl-user, utl-internal, cmd-${_arg_command}" from "${app_root}"
	g_expect 'g_is_fn "cmd_run"'

	cmd_run
}; g_iife main "${@}"
