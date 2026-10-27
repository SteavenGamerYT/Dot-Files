#!/usr/bin/env bash

i=0
awk -F: '/cpu MHz/ {
    printf "Core %d: %.0f MHz\n", i++, $2
}' /proc/cpuinfo
