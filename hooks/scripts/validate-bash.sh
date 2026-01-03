#!/usr/bin/env bash
#
# validate-bash.sh - Command Safety Check Hook
# Validates bash commands for dangerous operations before execution
#
# Environment Variables:
#   CLAUDE_TOOL_INPUT - JSON containing the command to execute
#
# Exit Codes:
#   0 - Command is safe to execute
#   1 - Command is blocked (dangerous)
#   2 - Validation error
#

set -euo pipefail

LOG_FILE="${HOME}/.claude/hooks/logs/bash-validation.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date -Iseconds)] $*" >> "$LOG_FILE"
}

# Get tool input from environment
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"

if [[ -z "$TOOL_INPUT" ]]; then
    log "WARN: No tool input provided, skipping validation"
    exit 0
fi

# Extract command from JSON input
COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // empty' 2>/dev/null || echo "")

if [[ -z "$COMMAND" ]]; then
    log "WARN: No command found in input"
    exit 0
fi

log "INFO: Validating command: ${COMMAND:0:100}..."

# === DESTRUCTIVE COMMAND PATTERNS ===
# These patterns are blocked unconditionally

BLOCKED_PATTERNS=(
    # Recursive force delete on root or system directories
    'rm\s+(-[a-zA-Z]*)?-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*\s+/'
    'rm\s+(-[a-zA-Z]*)?-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*\s+/'
    'rm\s+-rf\s+/'
    'rm\s+-fr\s+/'
    'rm\s+--force\s+--recursive\s+/'
    'rm\s+--recursive\s+--force\s+/'
    # Direct disk operations
    '\bdd\s+.*of=/dev/(s|h|v|xv)d[a-z]'
    '\bdd\s+.*of=/dev/nvme'
    '\bdd\s+.*of=/dev/disk'
    # Filesystem creation (can destroy data)
    '\bmkfs\b'
    '\bmkfs\.[a-z0-9]+\b'
    '\bmke2fs\b'
    # Fork bombs
    ':\(\)\s*\{\s*:\|:\s*&\s*\}\s*;'
    ':\s*\(\)\s*\{\s*:\s*\|\s*:\s*&\s*\}'
    # Format commands
    '\bformat\s+[cCdDeEfFgGhH]:'
    # Overwrite MBR/boot sector
    'dd\s+.*of=/dev/(s|h|v)d[a-z]\s*$'
    # Dangerous chmod/chown on root
    'chmod\s+(-R|--recursive)\s+777\s+/'
    'chown\s+(-R|--recursive)\s+.*\s+/'
    # Kernel/system destruction
    'rm\s+.*(/boot/|/lib/modules/|/usr/lib/)'
    # Network destruction
    'iptables\s+-F'
    'iptables\s+--flush'
    # Dangerous curl/wget pipes
    'curl\s+.*\|\s*(sudo\s+)?bash'
    'wget\s+.*\|\s*(sudo\s+)?bash'
    'curl\s+.*\|\s*(sudo\s+)?sh'
    'wget\s+.*\|\s*(sudo\s+)?sh'
    # System halt/reboot without confirmation
    '\bhalt\b'
    '\bpoweroff\b'
    '\bshutdown\b'
    '\breboot\b'
    '\binit\s+0\b'
    '\binit\s+6\b'
    # Kill all processes
    'kill\s+-9\s+-1'
    'killall\s+-9\s+'
    'pkill\s+-9\s+.'
    # Disk wipe utilities
    '\bshred\s+.*(/dev/|--)'
    '\bwipe\b'
    '\bsecure-delete\b'
    # Dangerous git operations
    'git\s+push\s+.*--force\s+.*main'
    'git\s+push\s+.*--force\s+.*master'
    'git\s+push\s+-f\s+.*main'
    'git\s+push\s+-f\s+.*master'
    # History manipulation
    'history\s+-c'
    'history\s+--clear'
    # Environment destruction
    'unset\s+PATH'
    'export\s+PATH\s*=\s*$'
    # Cron destruction
    'crontab\s+-r'
)

# Check against blocked patterns
for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qE "$pattern" 2>/dev/null; then
        log "BLOCKED: Dangerous command detected: $COMMAND"
        echo "BLOCKED: Dangerous command pattern detected. This operation could cause system damage or data loss." >&2
        echo "Pattern matched: $pattern" >&2
        exit 1
    fi
done

# === SUDO OPERATIONS WARNING (logged but allowed) ===
if echo "$COMMAND" | grep -qE '^\s*sudo\s+' 2>/dev/null; then
    log "WARN: Sudo command detected, proceeding with caution: $COMMAND"
fi

# === HIGH-RISK OPERATIONS (logged but allowed) ===
HIGH_RISK_PATTERNS=(
    'rm\s+-r'
    'chmod\s+-R'
    'chown\s+-R'
    'docker\s+system\s+prune'
    'docker\s+volume\s+rm'
    'git\s+reset\s+--hard'
    'git\s+clean\s+-fd'
    'npm\s+cache\s+clean'
    'pip\s+uninstall'
)

for pattern in "${HIGH_RISK_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qE "$pattern" 2>/dev/null; then
        log "WARN: High-risk command detected: $COMMAND"
        break
    fi
done

log "PASSED: Command validation successful"
exit 0
