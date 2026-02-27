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
pactl set-sink-volume alsa_output.pci-0000_01_00.1.pro-output-3 20%
pactl set-sink-volume alsa_output.pci-0000_01_00.1.pro-output-7 20%
pactl set-sink-volume alsa_output.pci-0000_01_00.1.pro-output-8 20%
pactl set-sink-volume alsa_output.pci-0000_01_00.1.pro-output-9 20%

# Change Laptop Speekers Audio to 20% to prevent loud noise on startup
pactl set-sink-volume alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink 20%

# Change PC Speekers Audio to 20% to prevent loud noise on startup
amixer -c CS202 set PCM 100%
pactl set-sink-volume alsa_output.usb-Generic_CS202_20210726905926-00.iec958-stereo 20%

# Set internal laptop mic to 46%
pactl set-source-volume alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source 46%

# Load echo-cancel module if not already loaded
if ! pactl list modules short | grep -q module-echo-cancel; then
    pactl load-module module-echo-cancel aec_method=webrtc aec_args="noise_suppression=1"
fi

# Make PC Speakers default
pactl set-default-sink alsa_output.usb-Generic_CS202_20210726905926-00.iec958-stereo

# Make echo-cancel mic default
pactl set-default-source echo-cancel-source