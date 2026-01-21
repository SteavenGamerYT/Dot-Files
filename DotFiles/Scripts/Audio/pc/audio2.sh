#!/usr/bin/env bash
# set -x

# Function to enable all expect tv
enable_all() {
    # Set audio profiles
    pactl set-card-profile alsa_card.pci-0000_08_00.1 pro-audio
    pactl set-card-profile alsa_card.pci-0000_03_00.1 pro-audio
    pactl set-card-profile alsa_card.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00 output:iec958-stereo+input:mono-fallback
    pactl set-card-profile alsa_card.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00 output:iec958-stereo+input:mono-fallback

    # Change Headset PCM to 100%
    amixer -c headset set PCM 100%
    amixer -c headset set PCM,1 100%
    amixer -c Headset set PCM 100%
    amixer -c Headset set PCM,1 100%

    # Set H848 Wireless Headset as default audio
    pactl set-default-sink alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo
    pactl set-default-source alsa_input.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.mono-fallback

    # Audio links
    pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-3
    pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00.iec958-stereo

    sleep 2

    pw-link alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-3
    pw-link alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00.iec958-stereo
}

# Function to disable all expect tv
disable_all() {
    pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-3
    pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.usb-XiiSound_Technology_Corporation_H848_USB_Gaming_Headset-00.iec958-stereo
}

# Function to enable TV
enable_tv() {
    pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-7
    sleep 2
    pw-link alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-7
}

# Function to disable TV
disable_tv() {
    pw-link -d alsa_output.usb-XiiSound_Technology_Corporation_H848_Wireless_headset-00.iec958-stereo alsa_output.pci-0000_03_00.1.pro-output-7
}

# Main logic
case "$1" in
    enable)
        case "$2" in
            all)
                enable_all
                ;;
            tv)
                enable_tv
                ;;
            *)
                echo "Invalid option for enable. Use: all or tv."
                ;;
        esac
        ;;
    disable)
        case "$2" in
            all)
                disable_all
                ;;
            tv)
                disable_tv
                ;;
            *)
                echo "Invalid option for disable. Use: all or tv."
                ;;
        esac
        ;;
    *)
        echo "Usage: $0 {enable|disable} {all|tv}"
        ;;
esac