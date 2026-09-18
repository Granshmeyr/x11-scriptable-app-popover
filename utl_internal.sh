main() {
	utl_get_wid_file() {
		local -n out_file="${1}"

		out_file="${app_root}/wid.txt"
	}

	utl_set_wid() {
		local arg_value="$1"
		local wid_file; utl_get_wid_file wid_file

		echo "$arg_value" > "${wid_file}"
	}

	utl_kdocker_call() {
		local arg_method="$1"
		local arg_arg="$2"

		dbus-send --session --print-reply --type=method_call \
			--dest=com.kdocker.KDocker /manage \
			"com.kdocker.KdockerInterface.${arg_method}" "${arg_arg}"
	}

	utl_get_window_state() {
		local -n out_state="${1}"
		local wid; get_wid wid

		out_state="$(xprop -id "${wid}" | awk -F': ' '/window state/ {print $2}')"
	}

	utl_search_wid_from_class() {
		local -n out_wid="${1}"
		local arg_class="${2}"

		out_wid="$(xdotool search --onlyvisible --class "${arg_class}" 2>/dev/null | \
			tail -n 1)"
	}

	utl_ms_to_sec() {
		local -n out_sec="${1}"
		local arg_ms="${2}"
		local padded

		printf -v padded "%04d" "${arg_ms}"
		out_sec="${padded:0:-3}.${padded:-3}"
	}
}; g_iife main
