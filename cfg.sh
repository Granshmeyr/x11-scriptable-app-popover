main() {
	# configure variables and functions below

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
		local wid; get_wid wid

		set_window_rect "0" "0" "3840" "2160"
		icesh -window "${wid}" setLayer OnTop
	}

	pre_hide() {
		set_window_rect "0" "0" "3840" "2160"
	}

	post_hide() { :; }
}; g_iife main
