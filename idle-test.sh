#!/bin/bash
LOG_FILE="/tmp/idle_test_weekly.log"

# For testing, shrink the max logs to just 5 entries (simulate 5 minutes)
MAX_LOGS=5

# Use first arg to simulate RAM average (ex. bash idle-test.sh 42)
# No arg falls back to your current RAM usage
# In production, this would be: $(free | awk '/Mem/ {printf("%d"), $3/$2 * 100}')
CURRENT="${1:-$(free | awk '/Mem/ {printf("%d"), $3/$2 * 100}')}"

# Append to log
echo "$CURRENT" >> "$LOG_FILE"

# Keep only the last 5 entries
if [ $(wc -l < "$LOG_FILE") -gt $MAX_LOGS ]; then
    tail -n "$MAX_LOGS" "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

# Calculate average
AVERAGE=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' "$LOG_FILE")
AVG_INT=$(printf "%.0f" "$AVERAGE")

echo "🧪 DEBUG: Current mock average is ${AVG_INT}%"

# Test the notification trigger
if [ "$AVG_INT" -gt 5 ]; then
    notify-send -u critical "🚨 IDLE MAXING VIOLATION (TEST) 🚨" \
        "Weekly RAM average is ${AVG_INT}%. Sam Altman's McLaren is idling."
else
    notify-send "✅ IDLE MAXING COMPLIANT (TEST)" \
        "Mock average is ${AVG_INT}%."
fi
