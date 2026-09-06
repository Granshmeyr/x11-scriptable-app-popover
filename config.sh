_configure_stuff_in_here() {
	TRY_TO_DETECT_CREATED_WINDOW_TIMEOUT_MS=1000
	CREATED_WINDOW_CLASS_FROM_XPROP="google-chrome"

	create_window() {
		google-chrome-stable \
			--user-data-dir="/home/grindle/.config/gemini-popover-chrome" \
			'https://gemini.google.com/app'
	}

	pre_dock() { :; }

	post_dock() {
		set_window_rect "0" "0" "3840" "2160"
		hide_window
	}

	pre_show() { :; }

	post_show() {
		set_window_rect "0" "0" "3840" "2160"
		icesh -window "$(get_wid)" setLayer OnTop
	}

	pre_hide() {
		set_window_rect "0" "0" "3840" "2160"
	}

	post_hide() { :; }
}

if [[ "$APP_POPOVER" =~ ^-?0+$ ]]; then
	_configure_stuff_in_here
else
	echo "This file cannot be ran directly." >&2

	exit 1
fi
