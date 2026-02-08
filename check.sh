#!/bin/bash

# Exit on error, undefined variables
set -euo pipefail

# Get script directory for reliable path resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR

# Define file paths
readonly CONFIG="${SCRIPT_DIR}/config.json"
readonly LOG="${SCRIPT_DIR}/log"
readonly MESSAGE="${SCRIPT_DIR}/message"

# Error handling function
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Validate required files exist
[[ -f "$CONFIG" ]] || error_exit "Configuration file not found: $CONFIG"
[[ -f "$LOG" ]] || error_exit "Log file not found: $LOG"
[[ -f "$MESSAGE" ]] || error_exit "Message file not found: $MESSAGE"

# Check required commands
for cmd in jq dateutils.ddiff msmtp; do
    command -v "$cmd" >/dev/null 2>&1 || error_exit "Required command not found: $cmd"
done

# Note: msmtp configuration is checked at send time, not here
# This allows the script to run checks without requiring a full mail setup

# Read configuration using jq -r (raw output, no quotes needed)
myMail=$(jq -r '.config.myself' "$CONFIG") || error_exit "Failed to read 'myself' from config"
units=$(jq -r '.config.units' "$CONFIG") || error_exit "Failed to read 'units' from config"
timeMail=$(jq -r '.config.timeMail' "$CONFIG") || error_exit "Failed to read 'timeMail' from config"
timeLastCall=$(jq -r '.config.timeLastCall' "$CONFIG") || error_exit "Failed to read 'timeLastCall' from config"
timeSOS=$(jq -r '.config.timeSOS' "$CONFIG") || error_exit "Failed to read 'timeSOS' from config"
url=$(jq -r '.config.url' "$CONFIG") || error_exit "Failed to read 'url' from config"
recipient=$(jq -r '.config.recipient' "$CONFIG") || error_exit "Failed to read 'recipient' from config"

# Validate configuration values are not empty
[[ -n "$myMail" ]] || error_exit "Configuration 'myself' is empty"
[[ -n "$units" ]] || error_exit "Configuration 'units' is empty"
[[ -n "$timeMail" ]] || error_exit "Configuration 'timeMail' is empty"
[[ -n "$timeLastCall" ]] || error_exit "Configuration 'timeLastCall' is empty"
[[ -n "$timeSOS" ]] || error_exit "Configuration 'timeSOS' is empty"
[[ -n "$url" ]] || error_exit "Configuration 'url' is empty"
[[ -n "$recipient" ]] || error_exit "Configuration 'recipient' is empty"

# Get current timestamp
now=$(date +'%Y-%m-%dT%H:%M:%S')

# Read last pings from log (handle empty log file)
if [[ ! -s "$LOG" ]]; then
    error_exit "Log file is empty. Initialize it with a timestamp first."
fi

lastPing=$(tail -n 1 "$LOG" | tr -d '\n\r')
previousPing=$(tail -n 2 "$LOG" | head -n 1 | tr -d '\n\r')

# Validate that lastPing was read
[[ -n "$lastPing" ]] || error_exit "Could not read last ping from log"

# Calculate time difference
if [[ "$lastPing" == "ko" ]] || [[ "$lastPing" == "koSOS" ]] || [[ "$lastPing" == "SOS" ]]; then
    # If last ping was a status marker, use the previous timestamp
    [[ -n "$previousPing" ]] || error_exit "No previous timestamp found in log"
    diffPing=$(dateutils.ddiff "$previousPing" "$now" -f "%${units}") || error_exit "Failed to calculate time difference"
else
    # Otherwise, use the last ping timestamp
    diffPing=$(dateutils.ddiff "$lastPing" "$now" -f "%${units}") || error_exit "Failed to calculate time difference"
fi

# Remove any decimal points from diffPing for integer comparison
# dateutils.ddiff may return decimal values (e.g., "30.5"), but bash's -ge
# operator requires integers. We truncate to get whole units (e.g., "30").
diffPing=${diffPing%%.*}

# Send appropriate alerts based on state and time elapsed
if [[ "$lastPing" == "koSOS" ]] && [[ "$diffPing" -ge "$timeSOS" ]]; then
    # Send SOS message
    {
        echo "Subject: SOS MAIL of $myMail"
        echo ""
        cat "$MESSAGE"
    } | msmtp "$recipient" || error_exit "Failed to send SOS email"
    
    echo "$now" >> "$LOG"
    echo "SOS" >> "$LOG"
    
elif [[ "$lastPing" == "ko" ]] && [[ "$diffPing" -ge "$timeLastCall" ]]; then
    # Send last call warning
    {
        echo "Subject: LAST CALL: Are you alive?"
        echo ""
        echo "Go to $url to say that you are alive! THIS IS THE LAST CALL"
    } | msmtp "$myMail" || error_exit "Failed to send last call email"
    
    echo "$now" >> "$LOG"
    echo "koSOS" >> "$LOG"
    
elif [[ "$lastPing" != "SOS" ]] && [[ "$diffPing" -ge "$timeMail" ]]; then
    # Send initial warning
    {
        echo "Subject: Are you alive?"
        echo ""
        echo "Go to $url to say that you are alive!"
    } | msmtp "$myMail" || error_exit "Failed to send warning email"
    
    echo "$now" >> "$LOG"
    echo "ko" >> "$LOG"
fi

exit 0
