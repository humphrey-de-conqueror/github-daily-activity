#!/bin/bash

REPO_PATH="$HOME/github-daily-activity"
SNIPPET_DIR="$REPO_PATH/src/snippets"
INDEX_FILE="$REPO_PATH/src/index.js"
DATE=$(date +"%Y%m%d")
HUMAN_DATE=$(date +"%Y-%m-%d %H:%M:%S")

mkdir -p "$SNIPPET_DIR"
cd "$REPO_PATH" || exit 1

# Generate a small code snippet (this can be improved by the AI agent per run)
# For now, we'll use a placeholder that describes the contribution
cat <<EOF > "$SNIPPET_DIR/snippet_$DATE.js"
/**
 * Daily Utility: $HUMAN_DATE
 * Purpose: Simple activity contribution.
 */
function dailyTask_$DATE() {
  console.log("Executing task for $HUMAN_DATE");
}

module.exports = dailyTask_$DATE;
EOF

# Update the main index to point to the latest
echo "module.exports = require('./snippets/snippet_$DATE');" > "$INDEX_FILE"

# Git operations
git add .
git commit -m "feat: add daily code snippet $DATE"
git push origin master
