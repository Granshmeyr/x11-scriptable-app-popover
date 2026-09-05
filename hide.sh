_main() {
	using_util

	if ! is_window_visible; then
		exit 0
	fi

	hide_window
}

if [[ "$APP_POPOVER" =~ ^-?0+$ ]]; then
	_main
else
	echo "This file cannot be ran directly. Use 'app-popover hide' instead." >&2

	exit 1
fi
