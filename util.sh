_main() {
	# window

	is_window_visible() {
		if [[ "$(get_window_state)" = "Normal" ]]; then
			return 0
		fi
		
		return 1
	}

	dock_window() {
		kdocker_call "dockWindowId" "uint32:$(get_wid)"
	}

	show_window() {
		using_config

		local desktop="$(xdotool get_desktop)"
		local wid="$(get_wid)"

		pre_show
		kdocker_call "showWindow" "uint32:$(get_wid)"
		xdotool set_desktop_for_window "$wid" "$desktop" windowactivate "$wid"
		post_show
	}

	hide_window() {
		using_config

		pre_hide
		kdocker_call "hideWindow" "uint32:$(get_wid)"
		post_hide
	}

	toggle_window() {
		if is_window_visible; then
			hide_window
		else
			show_window
		fi
	}

	set_window_rect() {
		local arg_x="$1"
		local arg_y="$2"
		local arg_width="$3"
		local arg_height="$4"

		wmctrl -i -r "$(get_wid)" -e "0,$arg_x,$arg_y,$arg_width,$arg_height"
	}

	maximize_window() {
		local wid="$(get_wid)"

		wmctrl -i -r "$wid" -b remove,hidden
		wmctrl -i -r "$wid" -b add,maximized_vert,maximized_horz
	}

	minimize_window() {
		local wid="$(get_wid)"

		wmctrl -i -r "$wid" -b remove,maximized_vert,maximized_horz
		wmctrl -i -r "$wid" -b add,hidden
	}

	# internal

	get_wid_file() {
		echo "$(get_proj_dir)/wid.txt"
	}

	set_wid() {
		local arg_value="$1"

		echo "$arg_value" > "$(get_wid_file)"
	}

	get_wid() {
		cat -- "$(get_wid_file)"
	}


	kdocker_call() {
		local arg_method="$1"
		local arg_arg="$2"

		dbus-send --session --print-reply --type=method_call \
		--dest=com.kdocker.KDocker /manage \
		"com.kdocker.KdockerInterface.$arg_method" "$arg_arg"
	}

	get_window_state() {
		echo "$(xprop -id "$(get_wid)" | awk -F': ' '/window state/ {print $2}')"
	}

	search_wid_from_class() {
		local arg_class="$1"

		echo "$(xdotool search --onlyvisible --class "$arg_class" 2>/dev/null | \
			tail -n 1)"
	}

	ms_to_sec() {
		local arg_ms="$1"

		if [[ -z "$arg_ms" ]]; then
			err "Invalid arg."

			exit 1
		fi

		bc -l <<< "scale=3; $arg_ms / 1000"
	}
}


if [[ "$APP_POPOVER" =~ ^-?0+$ ]]; then
	_main
else
	echo "This file cannot be ran directly." >&2

	exit 1
fi
