#!/bin/sh
mpv --config-dir=/dev/null --no-video --no-resume-playback "$( find ~/Audio/mp3/Sounds/notification -type f | sort -R | head -n 1 )"