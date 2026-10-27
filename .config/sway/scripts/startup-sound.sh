#!/usr/bin/env bash

beep -f 659 -l 150   # E5
beep -f 784 -l 150   # G5
beep -f 988 -l 150   # B5
beep -f 1318 -l 300  # E6 (high)
beep -f 988 -l 150   # B5
beep -f 784 -l 150   # G5
beep -f 659 -l 150   # E5

# mpv --config-dir=/dev/null --no-video --no-resume-playback "$(find ~/Audio/mp3/Sounds/startup -type f | sort -R | head -n 1)"
mpv --config-dir=/dev/null --no-video --no-resume-playback ~/Audio/mp3/Sounds/startup/sonic.wav