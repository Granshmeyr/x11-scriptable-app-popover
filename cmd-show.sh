main() {
	cmd_run() {
		if utl_is_window_visible; then
			exit 0
		fi

		utl_show_window
	}
}; g_iife main
