#!/bin/bash
# Adds one small dated snippet, re-points the index at the newest snippet, commits and pushes.
# Usage: ./daily_commit.sh [YYYYMMDD]   (no arg = today; an older date backfills a missed day)

set -u

REPO_PATH="$HOME/github-daily-activity"
SNIPPET_DIR="$REPO_PATH/src/snippets"
INDEX_FILE="$REPO_PATH/src/index.js"

TODAY=$(date +"%Y%m%d")
DATE="${1:-$TODAY}"
if [[ ! "$DATE" =~ ^[0-9]{8}$ ]]; then
  echo "error: expected YYYYMMDD, got '$DATE'" >&2
  exit 2
fi
HUMAN_DATE="${DATE:0:4}-${DATE:4:2}-${DATE:6:2} 09:00:00"

cd "$REPO_PATH" || exit 1
mkdir -p "$SNIPPET_DIR"

# Idempotent: one snippet per day, never a second commit for the same date.
if [ -f "$SNIPPET_DIR/snippet_$DATE.js" ]; then
  echo "nothing to do: snippet_$DATE.js already exists"
  exit 0
fi

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

# The index always points at the newest snippet, so a backfill never rewinds it.
LATEST=$(find "$SNIPPET_DIR" -name 'snippet_*.js' -printf '%f\n' | sort | tail -1 | sed 's/^snippet_//; s/\.js$//')
echo "module.exports = require('./snippets/snippet_$LATEST');" > "$INDEX_FILE"

git add . || exit 1

# A backfilled day keeps its own commit date so the contribution graph shows that day.
if [ "$DATE" != "$TODAY" ]; then
  export GIT_AUTHOR_DATE="$HUMAN_DATE +0800"
  export GIT_COMMITTER_DATE="$HUMAN_DATE +0800"
fi

if ! git diff --cached --quiet; then
  git commit -m "feat: add daily code snippet $DATE" || exit 1
  git push origin master || exit 1
  echo "pushed snippet_$DATE.js ($(git rev-parse --short HEAD))"
else
  echo "nothing to commit"
fi
