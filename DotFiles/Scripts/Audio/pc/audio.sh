#!/usr/bin/env bash
set -x

# set audio profiles

# TU116 High Definition Audio Controller
pactl set-card-profile alsa_card.pci-0000_08_00.1 pro-audio

# Rx 7600 xt
pactl set-card-profile alsa_card.pci-0000_03_00.1 pro-audio

# H848 Wireless Headset
pactl set-card-profile alsa_card.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00 output:iec958-stereo+input:mono-fallback

# H848 USB Headset
pactl set-card-profile alsa_card.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00 output:iec958-stereo+input:mono-fallback

# Change Headset pcm to 100%
amixer -c headset set PCM 100%
amixer -c headset set PCM,1 100%
amixer -c Headset set PCM 100%
amixer -c Headset set PCM,1 100%

# Set H848 Wireless Headset as default audio
pactl set-default-sink alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo

# Set H848 Wireless Headset as default mic
pactl set-default-source alsa_input.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.mono-fallback

# Audio
# undo first
pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-3
pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00.iec958-stereo

sleep 2

# do it now
pw-link alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-3
pw-link alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00.iec958-stereo

# Extra for tv
# undo first
# pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-7

# sleep 2

# do it now
# pw-link alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-7


# Mic
# undo first
# pactl list short modules | grep "source=alsa_input.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.mono-fallback" | awk '{print $1}' | xargs -I {} pactl unload-module {}

# sleep 2

# do it now
# pactl load-module module-loopback source=alsa_input.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.mono-fallback sink=alsa_output.pci-0000_07_00.6.analog-stereo