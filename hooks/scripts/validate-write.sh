#!/usr/bin/env bash
#
# validate-write.sh - File Write Validation Hook
# Validates file writes for security concerns before allowing edits
#
# Environment Variables:
#   CLAUDE_TOOL_INPUT - JSON containing file_path and content
#   CLAUDE_FILE_PATH  - Path to file being written (if available)
#
# Exit Codes:
#   0 - Validation passed
#   1 - Validation failed (blocked)
#   2 - Validation error
#

set -euo pipefail

LOG_FILE="${HOME}/.claude/hooks/logs/write-validation.log"
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

# Extract file path and content from JSON input
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // empty' 2>/dev/null || echo "")
CONTENT=$(echo "$TOOL_INPUT" | jq -r '.content // .new_string // empty' 2>/dev/null || echo "")

log "INFO: Validating write to: ${FILE_PATH:-unknown}"

# === PATH TRAVERSAL CHECK ===
if [[ -n "$FILE_PATH" ]]; then
    # Check for path traversal attempts
    if [[ "$FILE_PATH" == *".."* ]]; then
        log "BLOCKED: Path traversal detected in: $FILE_PATH"
        echo "BLOCKED: Path traversal attempt detected (..)" >&2
        exit 1
    fi
    
    # Check for absolute paths to sensitive directories
    SENSITIVE_PATHS=(
        "/etc/passwd"
        "/etc/shadow"
        "/etc/sudoers"
        "/root/"
        "/var/log/"
        "/.ssh/"
        "/.gnupg/"
        "/.aws/credentials"
        "/.kube/config"
    )
    
    for sensitive in "${SENSITIVE_PATHS[@]}"; do
        if [[ "$FILE_PATH" == *"$sensitive"* ]]; then
            log "BLOCKED: Attempt to write to sensitive path: $FILE_PATH"
            echo "BLOCKED: Cannot write to sensitive system path: $sensitive" >&2
            exit 1
        fi
    done
fi

# === CREDENTIAL DETECTION ===
if [[ -n "$CONTENT" ]]; then
    # Patterns for hardcoded credentials
    CREDENTIAL_PATTERNS=(
        # AWS Keys
        'AKIA[0-9A-Z]{16}'
        # AWS Secret
        '["\x27][A-Za-z0-9/+=]{40}["\x27]'
        # GitHub Token
        'gh[pousr]_[A-Za-z0-9_]{36,}'
        # Generic API Key patterns
        'api[_-]?key["\x27]?\s*[:=]\s*["\x27][A-Za-z0-9_-]{20,}["\x27]'
        'apikey\s*=\s*["\x27][^"\x27]{20,}["\x27]'
        # Generic Secret patterns
        'secret[_-]?key["\x27]?\s*[:=]\s*["\x27][A-Za-z0-9_-]{20,}["\x27]'
        # Private keys
        '-----BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY-----'
        # Password in config
        'password["\x27]?\s*[:=]\s*["\x27][^"\x27]{8,}["\x27]'
        # Database connection strings with password
        '(mysql|postgres|mongodb)://[^:]+:[^@]+@'
        # JWT tokens (simplified)
        'eyJ[A-Za-z0-9_-]*\.eyJ[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*'
        # Slack tokens
        'xox[baprs]-[0-9a-zA-Z-]+'
        # Stripe keys
        'sk_live_[0-9a-zA-Z]{24,}'
        'pk_live_[0-9a-zA-Z]{24,}'
    )
    
    for pattern in "${CREDENTIAL_PATTERNS[@]}"; do
        if echo "$CONTENT" | grep -qE "$pattern" 2>/dev/null; then
            log "BLOCKED: Potential credential detected matching pattern: $pattern"
            echo "BLOCKED: Potential hardcoded credential detected. Use environment variables or secrets manager." >&2
            exit 1
        fi
    done
    
    # Check for common sensitive variable names with literal values
    if echo "$CONTENT" | grep -qiE '(DB_PASSWORD|DATABASE_PASSWORD|MYSQL_PASSWORD|POSTGRES_PASSWORD|REDIS_PASSWORD|SECRET_KEY|ENCRYPTION_KEY|SIGNING_KEY)\s*=\s*["\x27][^$\{][^"\x27]+["\x27]' 2>/dev/null; then
        log "BLOCKED: Hardcoded password in config variable"
        echo "BLOCKED: Hardcoded password detected. Use environment variables." >&2
        exit 1
    fi
fi

log "PASSED: Write validation successful for: ${FILE_PATH:-unknown}"
exit 0
