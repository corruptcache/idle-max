#!/bin/bash
# Idle Maxing Weekly Compliance Audit
# Generated via ChatGPT (free tier) to minimize personal RAM usage.

LOG_FILE="$HOME/.cache/idle_max_weekly.log"
MAX_LOGS=10080 # 7 days at 1 check per minute (7 * 24 * 60)

# Get current RAM usage percentage

CURRENT="${1:-$(free | awk '/Mem/ {printf("%d"), $3/$2 * 100}')}"

# Append current usage to log
echo "$CURRENT" >> "$LOG_FILE"

# Maintain a rolling 7-day window
if [ $(wc -l < "$LOG_FILE") -gt $MAX_LOGS ]; then
    tail -n "$MAX_LOGS" "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

# Calculate the rolling 7-day average
AVERAGE=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' "$LOG_FILE")
AVG_INT=$(printf "%.0f" "$AVERAGE")

# Check compliance against Sam Altman's 5% rule
if [ "$AVG_INT" -gt 5 ]; then
    # Fire a desktop notification straight into Hyprland so you can't ignore it
    notify-send -u critical "🚨 IDLE MAXING VIOLATION 🚨" \
        "Weekly RAM average is ${AVG_INT}%. You are dangerously efficient. Close your tabs, put the device on a shelf, and migrate to a secondary rig immediately."
else
    # Success notification for the dedicated idler
    notify-send "✅ IDLE MAXING COMPLIANT" \
        "Weekly RAM average is locked at ${AVG_INT}%. You're using less RAM than Ram Altiman drives his Mclaren F1"
fi
