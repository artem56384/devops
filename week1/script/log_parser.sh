#!/bin/bash

LOG_FILE=""

if [ -f /var/log/syslog ]; then
    LOG_FILE="/var/log/syslog"
elif [ -f /var/log/messages ]; then
    LOG_FILE="/var/log/messages"
else
    echo "Log file /var/log/syslog or /var/log/messages does not exist"
    exit 1
fi

OUTPUT_FILE="errors_$(date +%F).log"

CURRENT_MONTH=$(date '+%b')
CURRENT_DAY=$(date '+%e')

grep "^$CURRENT_MONTH[[:space:]]\+$CURRENT_DAY " "$LOG_FILE" | \
grep -iE 'error|fail|critical' | tail -100 > "$OUTPUT_FILE"

ATTEMPT=1
MAX_ATTEMPTS=3

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    curl -sS -X POST https://httpbin.org/post \
        --data-binary @"$OUTPUT_FILE" \
        -H "Content-Type: text/plain" \
        -o /dev/null

    if [ $? -eq 0 ]; then
        echo "File successfully sent: $OUTPUT_FILE"
        exit 0
    else
        echo "No internet connection or request failed. Attempt $ATTEMPT of $MAX_ATTEMPTS."
        if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
            sleep 10
        fi
    fi

    ATTEMPT=$((ATTEMPT + 1))
done

echo "Failed to send file after 3 attempts"
exit 1
