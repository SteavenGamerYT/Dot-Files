#!/bin/sh

case "$1" in
    -usage)
        # GPU utilization with % sign
        nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1"%"}'
        ;;
    -temp)
        # GPU temperature with °C
        nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | awk '{print $1"°C"}'
        ;;
    -power)
        # GPU power draw with W
        nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | awk '{print $1"W"}'
        ;;
    *)
        echo "Usage: $0 [-usage|-temp|-power]"
        exit 1
        ;;
esac
