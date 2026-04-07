#!/usr/bin/env python3

import os
import sys
import time
import datetime
import requests

LOG_FILE = None

if os.path.exists("/var/log/syslog"):
    LOG_FILE = "/var/log/syslog"
elif os.path.exists("/var/log/messages"):
    LOG_FILE = "/var/log/messages"
else:
    print("Log file not found")
    sys.exit(1)

OUTPUT_FILE = f"errors_{datetime.date.today()}.log"

now = datetime.datetime.now()
time_threshold = now - datetime.timedelta(minutes=10)

keywords = ["error", "fail", "critical"]
found_lines = []

def parse_time(line):
    try:
        parts = line.split()
        month = parts[0]
        day = parts[1]
        time_str = parts[2]

        log_time = datetime.datetime.strptime(
            f"{month} {day} {time_str} {now.year}",
            "%b %d %H:%M:%S %Y"
        )
        return log_time
    except:
        return None

with open(LOG_FILE, "r") as f:
    for line in f:
        log_time = parse_time(line)
        if not log_time:
            continue

        if log_time >= time_threshold:
            lower = line.lower()
            if any(k in lower for k in keywords):
                found_lines.append(line)

with open(OUTPUT_FILE, "w") as f:
    f.writelines(found_lines)

attempt = 1
max_attempts = 3

while attempt <= max_attempts:
    try:
        with open(OUTPUT_FILE, "rb") as f:
            response = requests.post(
                "https://httpbin.org/post",
                data=f,
                timeout=5
            )

        if response.status_code == 200:
            print(f"File sent successfully: {OUTPUT_FILE}")
            sys.exit(0)
        else:
            raise Exception("Bad response")

    except Exception as e:
        print(f"No internet or request failed (attempt {attempt})")

        if attempt < max_attempts:
            time.sleep(10)

    attempt += 1

print("Failed after 3 attempts")
sys.exit(1)
