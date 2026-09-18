main() {
	g_import "cfg, utl_internal" from "${app_root}"

	is_window_visible() {
		local window_state; utl_get_window_state window_state

		if [[ "${window_state}" = "Normal" ]]; then
			return 0
		fi

		return 1
	}

	dock_window() {
		local wid; get_wid wid

		utl_kdocker_call "dockWindowId" "uint32:${wid}"
	}

	show_window() {
		local desktop="$(xdotool get_desktop)"
		local wid; get_wid wid

		pre_show
		utl_kdocker_call "showWindow" "uint32:${wid}"
		xdotool set_desktop_for_window "${wid}" "${desktop}" windowactivate "${wid}"
		post_show
	}

	hide_window() {
		local wid; get_wid wid

		pre_hide
		utl_kdocker_call "hideWindow" "uint32:${wid}"
		post_hide
	}

	toggle_window() {
		if is_window_visible; then
			hide_window
		else
			show_window
		fi
	}

	set_window_rect() {
		local arg_x="${1}"
		local arg_y="${2}"
		local arg_width="${3}"
		local arg_height="${4}"
		local wid; get_wid wid

		wmctrl -i -r "${wid}" -e "0,${arg_x},${arg_y},${arg_width},${arg_height}"
	}

	maximize_window() {
		local wid; get_wid wid

		wmctrl -i -r "${wid}" -b remove,hidden
		wmctrl -i -r "${wid}" -b add,maximized_vert,maximized_horz
	}

	minimize_window() {
		local wid; get_wid wid

		wmctrl -i -r "${wid}" -b remove,maximized_vert,maximized_horz
		wmctrl -i -r "${wid}" -b add,hidden
	}

	get_wid() {
		local -n out_wid="${1}"
		local wid_file; utl_get_wid_file wid_file

		IFS= read -r -d '' out_wid < "${wid_file}" || [[ -n "${out_wid}" ]]
		out_wid="${out_wid%$'\n'}"
	}
}; g_iife main
