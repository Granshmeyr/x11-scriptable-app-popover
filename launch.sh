main() {
	g_import "cfg, utl_internal, utl_user" from "${app_root}"

	local CREATE_WINDOW="cfg_create_window"
	local desktop="$(xdotool get_desktop)"

	"${CREATE_WINDOW}" &

	local wid=""
	local poll_ms=250
	local poll_sec; utl_ms_to_sec poll_sec "${poll_ms}"
	local elapsed_ms=0

	while [[ "${elapsed_ms}" -lt "${CFG_TRY_TO_DETECT_CREATED_WINDOW_TIMEOUT_MS}" ]]; do
		utl_search_wid_from_class wid "${CFG_CREATED_WINDOW_CLASS_FROM_XPROP}"

		if [[ -n "${wid}" ]]; then
			break
		fi

		sleep "${poll_sec}"

		elapsed_ms="$((elapsed_ms + poll_ms))"
	done

	if [[ -z "${wid}" ]]; then
		g_err "'${CREATE_WINDOW}' in 'config.sh' did not create a window with class '${CFG_CREATED_WINDOW_CLASS_FROM_XPROP}'."

		exit 1
	fi

	xdotool set_desktop "${desktop}"
	utl_set_wid "${wid}"
	cfg_pre_dock
	dock_window
	cfg_post_dock
}; g_iife main
