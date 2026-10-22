main() {
	# configure variables and functions below

	CFG_ID="chrome"
	CFG_TRY_TO_DETECT_CREATED_WINDOW_TIMEOUT_MS=1000
	CFG_CREATED_WINDOW_CLASS_FROM_XPROP="google-chrome"

	cfg_create_window() {
		google-chrome-stable \
			--user-data-dir="/home/grindle/.config/gemini-popover-chrome" \
			'https://gemini.google.com/app'
	}

	cfg_pre_dock() { :; }

	cfg_post_dock() {
		utl_set_window_rect "0" "0" "3840" "2160"
		utl_hide_window
	}

	cfg_pre_show() { :; }

	cfg_post_show() {
		local wid; utl_get_wid wid

		utl_set_window_rect "0" "0" "3840" "2160"
		icesh -window "${wid}" setLayer OnTop
	}

	cfg_pre_hide() {
		utl_set_window_rect "0" "0" "3840" "2160"
	}

	cfg_post_hide() { :; }
}; g_iife main
