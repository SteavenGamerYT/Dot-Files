#!/usr/bin/env bash
#awk '{printf "%.2f GiB\n", $1 / 1024}' <(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)

nvidia-smi --query-gpu=memory.total,memory.free --format=csv,noheader,nounits |
awk '{printf "%.2f GiB\n", ($1-$2)/1024}'
