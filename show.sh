main() {
	unset -f main

	if [[ ! "$APP_POPOVER" =~ ^-?0+$ ]]; then
		echo "This file cannot be ran directly. Use 'app-popover launch' instead." >&2

		exit 1
	fi

	using_util

	if is_window_visible; then
		exit 0
	fi

	show_window
}

main
