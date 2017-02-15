FROM ubuntu:xenial
MAINTAINER protomouse <root@protomou.se>

RUN apt-get -y update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install xserver-xorg-video-dummy xserver-xorg-input-void pulseaudio libxinerama1 libxcursor1 libxrandr2 libasound2 libpulse0 libssl1.0.0 \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

ADD xorg.conf /etc/X11/
ADD templates /root/.godot/templates
ADD godot /usr/local/libexec/
ADD wrapper.sh /usr/local/bin/godot

ENTRYPOINT ["/usr/local/bin/godot"]
