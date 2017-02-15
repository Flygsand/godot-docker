#!/bin/bash

set -eo pipefail

pidof Xorg >/dev/null || ( nohup Xorg -noreset +extension GLX +extension RANDR +extension RENDER :99 &>/dev/null & )
pidof pulseaudio >/dev/null || ( nohup pulseaudio -D &>/dev/null & )
export DISPLAY=:99
exec /usr/local/libexec/godot "$@"
