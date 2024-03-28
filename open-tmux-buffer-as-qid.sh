#!/bin/bash
## Get the current directory from the first argument
CURRENT_DIR="$1"

# Check if there is piped input
if [ -p /dev/stdin ]; then
  # If the script receives piped input, read from the pipe
  RAW_TEXT=$(cat)
else
  # Otherwise, get the content from the tmux buffer, trim whitespace, and remove unwanted characters
  RAW_TEXT=$(tmux show-buffer | xargs)
fi

# Function to open a file in Vim
open_file_in_vim() {
  local file_path="$1"
  if [[ -e "$file_path" ]]; then
    tmux split-window -h -p 50 -c "$CURRENT_DIR" "zsh -i -c 'nvim $file_path'"
  fi
}

# Function to open a URL
open_url() {
  local url="$1"
  open "$url"
}

# Adjusted regular expression to match a URL up to the first whitespace
URL_REGEX="(http|https):\/\/[^[:space:]]+"

# Use grep to find and extract the first URL up to a whitespace in RAW_TEXT
URL=$(echo "$RAW_TEXT" | grep -oE "$URL_REGEX")

# Check if there is a file path (absolute or relative) in the buffer
FILE_PATH=$(echo "$RAW_TEXT" | grep -oE '[a-zA-Z0-9_\/\.-]+\.(c|cpp|java|py|sh|rb|pl|php|js|html|css|scss|json|xml|yml|yaml|md|txt|ts|tsx)')

if [[ -n "$URL" ]]; then
  # If a URL is extracted, open it
  open_url "$URL"
elif [[ -n "$FILE_PATH" ]]; then
  # If a file path is found, open it in Vim
  open_file_in_vim "$FILE_PATH"
else
  # Loop through each line that matches the structured identifier pattern
  echo "$RAW_TEXT" | grep -oE 'qid::[a-z_]+:[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}' | while read -r QID; do
    URL="https://go/qid/$QID"
    open_url "$URL"
  done
fi
