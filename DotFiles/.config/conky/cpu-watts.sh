#!/usr/bin/env bash
set -euo pipefail

# Paths
PACKAGE_SRC="/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj"
CORE_SRC="/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:0/energy_uj"
PACKAGE_MAX=$(< /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/max_energy_range_uj)
CORE_MAX=$(< /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:0/max_energy_range_uj)

# Store last readings in user cache folder
CACHE_DIR="$HOME/.cache/cpu-watts"
mkdir -p "$CACHE_DIR"
PACKAGE_LAST="$CACHE_DIR/package_last"
CORE_LAST="$CACHE_DIR/core_last"

get_energy() { cat "$1"; } # microjoules
get_time_diff_s() { echo "scale=6; ($(date '+%s%N') - $(date '+%s%N' -r "$1")) / 1000000000" | bc -l; }

need_to_init_last() {
    local file="$1"
    [[ ! -f "$file" || $(echo "$(get_time_diff_s "$file") > 120" | bc) -eq 1 ]]
}

store_last_energy() { echo "$2" > "$1"; }

calc_power() {
    local last_file="$2" max_val="$3" energy last diff complement
    energy="$4"
    last=$(< "$last_file")
    diff=$(( energy - last ))

    local time_diff
    time_diff=$(get_time_diff_s "$last_file")

    if (( diff > 0 )); then
        echo "scale=3; ($diff / 1000000) / $time_diff" | bc -l
    else
        complement=$(( max_val - last ))
        echo "scale=3; (($energy + $complement) / 1000000) / $time_diff" | bc -l
    fi
}

# Package
pkg_energy=$(get_energy "$PACKAGE_SRC")
if need_to_init_last "$PACKAGE_LAST"; then
    store_last_energy "$PACKAGE_LAST" "$pkg_energy"
    sleep 1
    pkg_energy=$(get_energy "$PACKAGE_SRC")
fi
pkg_power=$(calc_power "$PACKAGE_SRC" "$PACKAGE_LAST" "$PACKAGE_MAX" "$pkg_energy")
store_last_energy "$PACKAGE_LAST" "$pkg_energy"

# Core
core_energy=$(get_energy "$CORE_SRC")
if need_to_init_last "$CORE_LAST"; then
    store_last_energy "$CORE_LAST" "$core_energy"
    sleep 1
    core_energy=$(get_energy "$CORE_SRC")
fi
core_power=$(calc_power "$CORE_SRC" "$CORE_LAST" "$CORE_MAX" "$core_energy")
store_last_energy "$CORE_LAST" "$core_energy"

# Sum and print
total=$(echo "scale=1; $pkg_power + $core_power" | bc -l)
echo "${total}W"
