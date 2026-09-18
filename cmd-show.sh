main() {
	run_command() {
		if is_window_visible; then
			exit 0
		fi

		show_window
	}
}; g_iife main
