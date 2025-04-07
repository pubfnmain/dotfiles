export PS1="\w > "
export PATH=${PATH}:~/.local/bin:~/.cargo/bin

if [ -z "${XDG_RUNTIME_DIR}" ]; then
	export XDG_RUNTIME_DIR=/tmp/$(id -u)-runtime-dir
	if ! [ -d "${XDG_RUNTIME_DIR}" ]; then
		mkdir "${XDG_RUNTIME_DIR}"
		chmod 0700 "${XDG_RUNTIME_DIR}"
	fi
fi

if [ -z "${WAYLAND_DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
	dwl -s "wl-script init"
fi

if ! command -v hx; then
	alias hx=helix
fi
