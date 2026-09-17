main() {
	unset -f main

	if [[ ! "$APP_POPOVER" =~ ^-?0+$ ]]; then
		echo "This file cannot be ran directly. Use 'app-popover toggle' instead." >&2

		exit 1
	fi

	using_util

	toggle_window
}

main
