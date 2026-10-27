#!/usr/bin/env bash

# Trap SIGPIPE to avoid broken pipe errors
trap '' SIGPIPE

# Your CPU usage logic
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle1=$((idle + iowait))
sleep 1
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle2=$((idle + iowait))

total_diff=$((total2 - total1))
idle_diff=$((idle2 - idle1))
usage=$((100 * (total_diff - idle_diff) / total_diff))
echo "${usage}%" 2>/dev/null