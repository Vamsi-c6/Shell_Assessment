#!/bin/bash

# -------------------------------
# 🗓️ Get current date
# -------------------------------
DATE=$(date +%F)
LOG_FILE="process_log_$DATE.log"
HIGH_MEM_FILE="high_mem_processes.log"

# -------------------------------
# 1️⃣ Log Running Processes
# -------------------------------
echo "🔍 Logging all running processes to $LOG_FILE ..."
ps aux > "$LOG_FILE"

# -------------------------------
# 2️⃣ Check for High Memory Usage (>30%)
# -------------------------------
echo "🔍 Checking for processes using more than 30% memory..."
HIGH_MEM_PROCESSES=$(ps aux --sort=-%mem | awk '$4 > 30')

if [ ! -z "$HIGH_MEM_PROCESSES" ]; then
    echo "⚠️ Warning: Processes using more than 30% memory found!"
    echo "$HIGH_MEM_PROCESSES" >> "$HIGH_MEM_FILE"
fi

# -------------------------------
# 3️⃣ Check Disk Usage on /
# -------------------------------
echo "🔍 Checking disk usage on root partition..."
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "⚠️ Warning: Disk usage on '/' is above 80% (${DISK_USAGE}%)"
fi

# -------------------------------
# 4️⃣ Display Summary
# -------------------------------
TOTAL_PROCESSES=$(ps aux | wc -l)
HIGH_MEM_COUNT=$(echo "$HIGH_MEM_PROCESSES" | wc -l)

echo "---------------- Summary ----------------"
echo "📊 Total running processes         : $TOTAL_PROCESSES"
echo "🔥 Processes > 30% memory usage    : $HIGH_MEM_COUNT"
echo "💾 Disk usage on '/' partition     : ${DISK_USAGE}%"
echo "----------------------------------------"
