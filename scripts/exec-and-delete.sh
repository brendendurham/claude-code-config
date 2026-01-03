#!/bin/bash
# Execute a script and delete it - for one-shot autonomous operations
# Usage: exec-and-delete.sh <script_path>

SCRIPT_TO_RUN="$1"

if [ -z "$SCRIPT_TO_RUN" ] || [ ! -f "$SCRIPT_TO_RUN" ]; then
    echo "Error: Script not found: $SCRIPT_TO_RUN" >&2
    exit 1
fi

# Make executable
chmod +x "$SCRIPT_TO_RUN"

# Execute
"$SCRIPT_TO_RUN"
EXIT_CODE=$?

# Delete
rm -f "$SCRIPT_TO_RUN"

exit $EXIT_CODE
