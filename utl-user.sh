main() {
	utl_is_window_visible() {
		local window_state; utl_get_window_state window_state

		if [[ "${window_state}" = "Normal" ]]; then
			return 0
		fi

		return 1
	}

	utl_dock_window() {
		local wid; utl_get_wid wid

		utl_kdocker_call "dockWindowId" "uint32:${wid}"
	}

	utl_show_window() {
		local desktop="$(xdotool get_desktop)"
		local wid; utl_get_wid wid

		cfg_pre_show
		utl_kdocker_call "showWindow" "uint32:${wid}"
		xdotool set_desktop_for_window "${wid}" "${desktop}" windowactivate "${wid}"
		cfg_post_show
	}

	utl_hide_window() {
		local wid; utl_get_wid wid

		cfg_pre_hide
		utl_kdocker_call "hideWindow" "uint32:${wid}"
		cfg_post_hide
	}

	utl_toggle_window() {
		if utl_is_window_visible; then
			utl_hide_window
		else
			utl_show_window
		fi
	}

	utl_set_window_rect() {
		local arg_x="${1}"
		local arg_y="${2}"
		local arg_width="${3}"
		local arg_height="${4}"
		local wid; utl_get_wid wid

		wmctrl -i -r "${wid}" -e "0,${arg_x},${arg_y},${arg_width},${arg_height}"
	}

	utl_maximize_window() {
		local wid; utl_get_wid wid

		wmctrl -i -r "${wid}" -b remove,hidden
		wmctrl -i -r "${wid}" -b add,maximized_vert,maximized_horz
	}

	utl_minimize_window() {
		local wid; utl_get_wid wid

		wmctrl -i -r "${wid}" -b remove,maximized_vert,maximized_horz
		wmctrl -i -r "${wid}" -b add,hidden
	}

	utl_get_wid() {
		local -n arg_out_wid="${1}"
		local wid_file; utl_get_wid_file wid_file

		IFS= read -r -d '' arg_out_wid < "${wid_file}" || [[ -n "${arg_out_wid}" ]]
		arg_out_wid="${arg_out_wid%$'\n'}"
	}
}; g_iife main
