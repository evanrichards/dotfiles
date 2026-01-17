#!/usr/bin/env python3
import json
import re
import sys

input_data = json.load(sys.stdin)
if input_data.get("tool_name") != "Bash":
    sys.exit(0)

command = input_data.get("tool_input", {}).get("command", "")

# Check for rm with force/recursive flags
if re.search(r'\brm\s+(-[rf]+\s+|.*-[rf])', command):
    print("Use `trash` instead of `rm -rf` for safer deletion.", file=sys.stderr)
    sys.exit(2)

sys.exit(0)
