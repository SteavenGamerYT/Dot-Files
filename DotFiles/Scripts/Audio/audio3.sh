#!/usr/bin/env bash

# Change Headset profile to the proper one
pactl set-card-profile alsa_card.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00 output:iec958-stereo+input:mono-fallback
pactl set-card-profile alsa_card.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00 output:iec958-stereo+input:mono-fallback

# Change Gpu Audio profiles to the proper ones
pactl set-card-profile alsa_card.pci-0000_08_00.1 pro-audio
pactl set-card-profile alsa_card.pci-0000_03_00.1 pro-audio

# Change Headset Audio to 100%
amixer -c headset set PCM 100%
amixer -c headset set PCM,1 100%
amixer -c Headset set PCM 100%
amixer -c Headset set PCM,1 100%
pactl set-sink-volume alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo 100%
pactl set-sink-volume alsa_output.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00.iec958-stereo 100%

# Change HDMI Audio to 50% and unused to 0% and muted
pactl set-sink-volume alsa_output.pci-0000_03_00.1.pro-output-3 50%
pactl set-sink-volume alsa_output.pci-0000_03_00.1.pro-output-7 50%
pactl set-sink-volume alsa_output.pci-0000_03_00.1.pro-output-8 0%
pactl set-sink-volume alsa_output.pci-0000_03_00.1.pro-output-9 0%
pactl set-sink-mute alsa_output.pci-0000_03_00.1.pro-output-8 1
pactl set-sink-mute alsa_output.pci-0000_03_00.1.pro-output-9 1

# Change Speekers Audio to 20% to prevent loud noise on startup
pactl set-sink-volume alsa_output.pci-0000_0a_00.6.analog-stereo 20%

# Set Speekers as default for Audio
pactl set-default-sink alsa_output.pci-0000_0a_00.6.analog-stereo