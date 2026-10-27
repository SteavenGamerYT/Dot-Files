#!/usr/bin/env bash

# Input date
time1="08/27/2024 3:23PM"

# Convert current time to Unix timestamp
current=$(date +%s)

# Convert input time to Unix timestamp
timestamp1=$(date -d "$time1" +%s)

# Calculate the difference in seconds between the current time and input time
time_progression=$((current - timestamp1))

# Calculate the number of days that have passed
days_done=$((time_progression / 86400))

# Calculate the timestamp for January 1, 2025
timestamp2025=$(date -d "08/27/2025" +%s)

# Calculate the number of seconds left until 2025
time_left=$((timestamp2025 - current))

# Calculate the number of days left until 2025
days_left=$((time_left / 86400))

# Output the number of days passed and days left
echo "$days_left" days