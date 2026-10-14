# script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

g_root_err_trap() {
	trap "g_err \"An error occured during execution.\"" ERR
}

g_launch_and_get_wid_by_class() {
	local -n arg_out_wid="${1}"
	local arg_cmd="${2}"
	local arg_class="${3}"
	local arg_timeout_secs="${4:-5}"

	eval "${arg_cmd}" &

	local wid=""
	local elapsed=0
	local step=1

	while [ -z "${wid}" ]; do
		if [ $((elapsed * step)) -ge $((arg_timeout_secs * 10)) ]; then
			g_err "Timed out waiting for window class '${arg_class}'."

			return 1
		fi

		sleep 0.1
		elapsed=$((elapsed + 1))
		wid=$(xdotool search --onlyvisible --class "${arg_class}" 2>/dev/null | tail -n 1)
	done

	arg_out_wid="${wid}"
}

g_is_fn() {
	local arg_fn_name="${1}"

	declare -F -- "${arg_fn_name}" &> /dev/null
}

g_expect() {
	local arg_expr="${1}"
	local arg_msg="${2}"

	if ! eval "${arg_expr}"; then
		g_err "Expect failed: ${arg_msg:-$arg_expr}"

		exit 1
	fi
}

g_iife() {
	local arg_fn="${1}"
	shift

	"${arg_fn}" "${@}"
	unset -f "${arg_fn}"
}

g_log() {
	local arg_prefix="${1}"
	local arg_prefix_color="${2}"
	local arg_msg_color="${3}"
	local arg_msg="${4}"
	local no_color='\033[0m'
	local dim='\033[2m'

	printf "%b%s:%b %b%s%b\n" \
		"${arg_prefix_color}" "${arg_prefix}" "${no_color}" \
		"${arg_msg_color}" "${arg_msg}" "${no_color}" >&2

	local depth=${#FUNCNAME[@]}
	local i

	for ((i = 1; i < depth; i++)); do
		local func="${FUNCNAME[i]}"
		local src="${BASH_SOURCE[i]##*/}"
		local line="${BASH_LINENO[i-1]}"

		if [[ "${i}" -eq 1 ]]; then
			printf "  ---> %s:%s (in %s())\n" "${src}" "${line}" "${func}" >&2
		else
			printf "  %b---> %s:%s (in %s())%b\n" "${dim}" "${src}" "${line}" "${func}" "${no_color}" >&2
		fi
	done
}

g_warn() {
	local arg_msg="${1}"
	local yellow='\e[0;33m'
	local bold_yellow='\e[1;33m'

	g_log "WARNING" "${bold_yellow}" "${yellow}" "${arg_msg}"
}

g_err() {
	local arg_msg="${1}"
	local red='\e[0;31m'
	local bold_red='\e[1;31m'

	g_log "ERROR" "${bold_red}" "${red}" "${arg_msg}"
}

g_import() {
	local arg_raw_import_str="${1}"
	local arg_from_dummy="${2}"
	local arg_dir="${3}"

	if [[ "${arg_from_dummy}" != "from" ]]; then
		g_err "Expected 'from' keyword, got '${arg_from_dummy}'."

		exit 1
	fi

	if [[ -z "${arg_dir}" ]]; then
		g_err "An import directory was not provided."

		exit 1
	fi

	local clean_imports="${arg_raw_import_str//,/ }"
	local file_name

	for file_name in ${clean_imports}; do
		local file="${arg_dir}/${file_name}.sh"

		if [[ ! -f "${file}" ]]; then
			g_err "Importing non-existent file '${file}'."

			exit 1
		fi

		source "${file}"
	done
}
