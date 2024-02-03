#!/bin/bash

# Check if there is piped input
if [ -p /dev/stdin ]; then
  # If the script receives piped input, read from the pipe
  RAW_TEXT=$(cat)
else
  # Otherwise, get the content from the tmux buffer, trim whitespace, and remove unwanted characters
  RAW_TEXT=$(tmux show-buffer | xargs)
fi

# Loop through each line that matches the structured identifier pattern
echo "$RAW_TEXT" | grep -oE 'qid::[a-z_]+:[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}' | while read -r QID; do
  if [[ -n "$QID" ]]; then
    URL="https://go/qid/$QID"
    open "$URL"
  else
    echo "No valid QID found in buffer."
    echo "Buffer content: $(tmux show-buffer)"
    exit 1
  fi
done
