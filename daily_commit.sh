#!/bin/bash

# Repository path
REPO_PATH="$HOME/github-daily-activity"
LOG_FILE="$REPO_PATH/ACTIVITY.md"

# Ensure the directory exists
cd "$REPO_PATH" || exit 1

# Update the log file with the current date and a simple coding fact or snippet
DATE=$(date +"%Y-%m-%d %H:%M:%S")
echo "### Daily Activity - $DATE" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Daily status update performed by DSH on behalf of $(whoami)." >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Git operations
git add "$LOG_FILE"
git commit -m "chore: daily status update $DATE"
git push origin master
