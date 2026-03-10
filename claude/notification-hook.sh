#!/usr/bin/env bash

data=$(cat)
cwd=$(echo "$data" | jq -r '.cwd // "unknown"')
dir="${cwd/#$HOME/~}"
branch=$(cd "$cwd" 2>/dev/null && git branch --show-current 2>/dev/null)
[[ -n "$branch" ]] && loc="$dir ⎇ $branch" || loc="$dir"
msg=$(echo "$data" | jq -r '.message // "알림"')

# macOS 알림
terminal-notifier -title "Claude Code" -message "[$loc] $msg" -sound default
