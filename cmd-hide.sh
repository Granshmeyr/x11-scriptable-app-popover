main() {
	cmd_run() {
		if ! is_window_visible; then
			exit 0
		fi

		utl_hide_window
	}
}; g_iife main
