#!/bin/bash

# Script to detect suspect SUID files
# Have to be run with root rights (sudo)

BASELINE_FILE="/var/log/suid_baseline.txt"
CURRENT_SCAN="/tmp/suid_current.txt"
DIFF_LOG="/var/log/suid_diff.log"
DATE_NOW=$(date "+%Y-%m-%d %H:%M%S")

# Checking for root rights
if [[ "$EUID" -ne 0 ]]; then
  echo "[ERROR] Please run this script as root (sudo)." >&2
  exit 1
fi

# Function to generate the actual list of SUID files (CURRENT_SCAN)
function scan_suid() {
  find / -type f -perm -4000 2>/dev/null | sort > "$CURRENT_SCAN"
}

# Function to initialized the baseline file if it is not existing yet
function initialize_baseline() {
    if [[ ! -f "$BASELINE_FILE" ]]; then
        echo "[INFO] Baseline file not found. Creating initial baseline..."
        cp "$CURRENT_SCAN" "$BASELINE_FILE"
        echo "[OK] Baseline file saved at $BASELINE_FILE"
        exit 0
    fi
}

# Function to compare suid baseline list with the actual list
function compare_suid() {
    echo "[$DATE_NOW] SUID scan launched..." >> "$DIFF_LOG"

    ADDED=$(comm -13 "$BASELINE_FILE" "$CURRENT_SCAN")
    REMOVED=$(comm -23 "$BASELINE_FILE" "$CURRENT_SCAN")

    if [[ -n "$ADDED" ]]; then
      echo "[$DATE_NOW] New SUID files detected:" >> "$DIFF_LOG"
      echo "$ADDED" >> "$DIFF_LOG"
    fi

    if [[ -n "$REMOVED" ]]; then
      echo "[$DATE_NOW] SUID files removed since last baseline:" >> "$DIFF_LOG"
      echo "$REMOVED" >> "$DIFF_LOG"
    fi

    if [[ -z "$ADDED" && -z "$REMOVED" ]]; then
      echo "[$DATE_NOW] No SUID changes detected." >> "$DIFF_LOG"
    fi
}

# Function to cleanup
function cleanup() {
  rm -f "$CURRENT_SCAN"
}

# Main execution of functions

scan_suid
initialize_baseline
compare_suid
cleanup

exit 0
