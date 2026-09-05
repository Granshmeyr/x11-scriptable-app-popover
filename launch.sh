_main() {
	using_config
	using_util

	local CREATE_WINDOW="create_window"
	local desktop="$(xdotool get_desktop)"

	$CREATE_WINDOW &

	local wid=""
	local poll_ms=250
	local elapsed_ms=0

	while [[ "$elapsed_ms" -lt "$TRY_TO_DETECT_CREATED_WINDOW_TIMEOUT_MS" ]]; do
		wid="$(search_wid_from_class "$CREATED_WINDOW_CLASS")"

		if [[ -n "$wid" ]]; then
			break
		fi

		sleep "$(ms_to_sec "$poll_ms")"

		elapsed_ms="$((elapsed_ms + poll_ms))"
	done

	if [[ -z "$wid" ]]; then
		err "'$create_window' in 'config.sh' did not create a window \
			with class '$CREATED_WINDOW_CLASS'."

		exit 1
	fi

	xdotool set_desktop "$desktop"
	set_wid "$wid"
	pre_dock
	dock_window
	post_dock
}

if [[ "$APP_POPOVER" =~ ^-?0+$ ]]; then
	_main
else
	echo "This file cannot be ran directly. Use 'app-popover launch' instead." >&2

	exit 1
fi
