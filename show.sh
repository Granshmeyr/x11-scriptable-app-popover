main() {
	g_import "utl_user" from "${app_root}"

	if is_window_visible; then
		exit 0
	fi

	show_window
}; g_iife main
