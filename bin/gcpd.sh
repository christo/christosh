#!/bin/bash

OS_TYPE=$(uname -s)

if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS version
    LAST_YEAR=$(date -v-365d +%Y-%m-%d)
else
    # Linux version 
    LAST_YEAR=$(date -d "365 days ago" +%Y-%m-%d)
fi

COMMIT_COUNT=$(git log --after="$LAST_YEAR" --oneline | wc -l)
AVERAGE=$(echo "scale=2; $COMMIT_COUNT / 365" | bc)

echo "Total commits in the past 365 days: $COMMIT_COUNT"
echo "Daily average: $AVERAGE commits per day"
