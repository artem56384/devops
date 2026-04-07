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
TMP_FILE=$(mktemp)

CURRENT_YEAR=$(date +%Y)
CURRENT_DATE=$(date '+%b %e')
CURRENT_HOUR=$(date '+%H')
CURRENT_MINUTE=$(date '+%M')

START_EPOCH=$(date -d '10 minutes ago' +%s)
END_EPOCH=$(date +%s)

awk -v year="$CURRENT_YEAR" \
    -v start="$START_EPOCH" \
    -v end="$END_EPOCH" '
{
    log_time = $1 " " $2 " " $3 " " year
    cmd = "date -d \"" log_time "\" +%s 2>/dev/null"
    cmd | getline log_epoch
    close(cmd)

    if (log_epoch >= start && log_epoch <= end) {
        print $0
    }
}
' "$LOG_FILE" | grep -iE 'error|fail|critical' > "$TMP_FILE"

cat "$TMP_FILE" > "$OUTPUT_FILE"
rm -f "$TMP_FILE"

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
