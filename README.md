# X11 Scriptable App Popover
This collection of scripts provides a simple api for programatically docking/undocking an app from the status tray with custom callbacks. You can use it to have a set-size Discord window popover with a hotkey in the middle of the screen, or something.

To configure, modify the stuff inside `_configure_stuff_in_here` within `config.sh` . See the `# window` section within `util.sh` for methods that are available inside callbacks like `post_dock`.

## Documentation
- `app-popover launch`
	- Runs `config.sh` → `create_window()` and docks the created window (if successfully detected).
	- Triggered callbacks: `pre_dock`, `post_dock`.
- `app-popover show`
	- Shows the window if it is not visible.
	- Triggered callbacks: `pre_show`, `post_show`.
- `app-popover hide`
	- Hides the window if it is visible.
	- Triggered callbacks: `pre_hide`, `post_hide`.
- `app-popover toggle`
	- Toggles between visible and not-visible states of the window.
	- Triggered callbacks: `pre_show`, `post_show`, `pre_hide`, `post_hide`.

## Tips
- You should turn off all the options in KDocker for the best experience. Right click the docked window icon in the status tray > Options > *disable every checkable option* > Save settings > Global (all new).
- Only works with one window at a time, but you can create multiple copies of this repo as a workaround.
- If you want to ensure the window has the same rect every time it pops up, copy the `set_window_rect` usage inside the source `config.sh`.

## Dependencies
- bash
- x11
- xprop
- xdotool
- wmctrl
- kdocker
- bc