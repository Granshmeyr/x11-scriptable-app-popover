_main() {
	using_util

	toggle_window
}

if [[ "$APP_POPOVER" =~ ^-?0+$ ]]; then
	_main
else
	echo "This file cannot be ran directly. Use 'app-popover toggle' instead." >&2

	exit 1
fi
