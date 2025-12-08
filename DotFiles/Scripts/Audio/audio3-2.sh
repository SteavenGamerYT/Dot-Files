#!/usr/bin/env bash

# Change Headset profile to the proper one
pactl set-card-profile alsa_card.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00 output:iec958-stereo+input:mono-fallback
pactl set-card-profile alsa_card.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00 output:iec958-stereo+input:mono-fallback

# Change Gpu Audio profiles to the proper ones
pactl set-card-profile alsa_card.pci-0000_01_00.1 pro-audio

# Change Headset Audio to 100%
amixer -c headset set PCM 100%
amixer -c headset set PCM,1 100%
amixer -c Headset set PCM 100%
amixer -c Headset set PCM,1 100%
pactl set-sink-volume alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo 100%
pactl set-sink-volume alsa_output.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00.iec958-stereo 100%

# Set all NVIDIA GPU Pro Audio sinks to 20% volume
for sink in $(pactl list short sinks | awk '{print $2}' | grep '^alsa_output.pci-0000_01_00.1.pro-output'); do
    pactl set-sink-volume "$sink" 20%
done

# Change Speekers Audio to 20% to prevent loud noise on startup
pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo 20%

# Set internal laptop mic to 10%
pactl set-source-volume alsa_input.pci-0000_00_1f.3.analog-stereo 10%

# Load echo-cancel module if not already loaded
if ! pactl list modules short | grep -q module-echo-cancel; then
    pactl load-module module-echo-cancel aec_method=webrtc aec_args="noise_suppression=1"
fi

# Make laptop speakers default
pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo

# Make echo-cancel mic default
pactl set-default-source echo-cancel-source