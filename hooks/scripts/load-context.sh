#!/usr/bin/env bash
#
# load-context.sh - Session Initialization Hook
# Loads project context and sets environment variables at session start
#
# Environment Variables (Input):
#   CLAUDE_SESSION_ID     - Current session identifier
#   CLAUDE_WORKING_DIR    - Current working directory
#   CLAUDE_PROJECT_ROOT   - Project root directory (if detected)
#
# Exit Codes:
#   0 - Context loaded successfully
#   1 - Error loading context (non-fatal, session continues)
#

set -euo pipefail

LOG_FILE="${HOME}/.claude/hooks/logs/session-init.log"
CONTEXT_CACHE="${HOME}/.claude/hooks/cache"

mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$CONTEXT_CACHE"

log() {
    echo "[$(date -Iseconds)] $*" >> "$LOG_FILE"
}

# === SESSION LOGGING ===
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
WORKING_DIR="${CLAUDE_WORKING_DIR:-$(pwd)}"

log "INFO: ========================================"
log "INFO: Session Start: $SESSION_ID"
log "INFO: Working Directory: $WORKING_DIR"
log "INFO: User: $(whoami)"
log "INFO: Host: $(hostname)"
log "INFO: ========================================"

# === PROJECT DETECTION ===
PROJECT_ROOT="$WORKING_DIR"
PROJECT_TYPE="unknown"
PROJECT_NAME="$(basename "$WORKING_DIR")"

# Walk up to find project root
find_project_root() {
    local dir="$1"
    while [[ "$dir" != "/" ]]; do
        # Check for common project markers
        if [[ -f "$dir/package.json" ]] || \
           [[ -f "$dir/Cargo.toml" ]] || \
           [[ -f "$dir/go.mod" ]] || \
           [[ -f "$dir/pyproject.toml" ]] || \
           [[ -f "$dir/setup.py" ]] || \
           [[ -f "$dir/pom.xml" ]] || \
           [[ -f "$dir/build.gradle" ]] || \
           [[ -f "$dir/.git" ]] || \
           [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    echo "$1"  # Return original if nothing found
}

PROJECT_ROOT=$(find_project_root "$WORKING_DIR")
log "INFO: Project Root: $PROJECT_ROOT"

# === DETECT PROJECT TYPE ===
detect_project_type() {
    local root="$1"
    
    if [[ -f "$root/package.json" ]]; then
        if [[ -f "$root/next.config.js" ]] || [[ -f "$root/next.config.mjs" ]]; then
            echo "nextjs"
        elif [[ -f "$root/angular.json" ]]; then
            echo "angular"
        elif [[ -f "$root/vue.config.js" ]] || grep -q '"vue"' "$root/package.json" 2>/dev/null; then
            echo "vue"
        elif grep -q '"react"' "$root/package.json" 2>/dev/null; then
            echo "react"
        else
            echo "nodejs"
        fi
    elif [[ -f "$root/Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "$root/go.mod" ]]; then
        echo "go"
    elif [[ -f "$root/pyproject.toml" ]] || [[ -f "$root/setup.py" ]]; then
        echo "python"
    elif [[ -f "$root/pom.xml" ]]; then
        echo "java-maven"
    elif [[ -f "$root/build.gradle" ]] || [[ -f "$root/build.gradle.kts" ]]; then
        echo "java-gradle"
    elif [[ -f "$root/Gemfile" ]]; then
        echo "ruby"
    elif [[ -f "$root/composer.json" ]]; then
        echo "php"
    else
        echo "unknown"
    fi
}

PROJECT_TYPE=$(detect_project_type "$PROJECT_ROOT")
log "INFO: Project Type: $PROJECT_TYPE"

# === LOAD PROJECT-SPECIFIC CONTEXT ===

# Extract project name from config files
if [[ -f "$PROJECT_ROOT/package.json" ]]; then
    PROJECT_NAME=$(jq -r '.name // empty' "$PROJECT_ROOT/package.json" 2>/dev/null || echo "$PROJECT_NAME")
elif [[ -f "$PROJECT_ROOT/Cargo.toml" ]]; then
    PROJECT_NAME=$(grep -E '^\s*name\s*=' "$PROJECT_ROOT/Cargo.toml" | head -1 | sed 's/.*=\s*"\(.*\)"/\1/' || echo "$PROJECT_NAME")
elif [[ -f "$PROJECT_ROOT/go.mod" ]]; then
    PROJECT_NAME=$(head -1 "$PROJECT_ROOT/go.mod" | awk '{print $2}' | xargs basename 2>/dev/null || echo "$PROJECT_NAME")
elif [[ -f "$PROJECT_ROOT/pyproject.toml" ]]; then
    PROJECT_NAME=$(grep -E '^\s*name\s*=' "$PROJECT_ROOT/pyproject.toml" | head -1 | sed 's/.*=\s*"\(.*\)"/\1/' || echo "$PROJECT_NAME")
fi

log "INFO: Project Name: $PROJECT_NAME"

# === GIT CONTEXT ===
GIT_BRANCH=""
GIT_REMOTE=""
GIT_STATUS=""

if [[ -d "$PROJECT_ROOT/.git" ]] || [[ -f "$PROJECT_ROOT/.git" ]]; then
    GIT_BRANCH=$(git -C "$PROJECT_ROOT" branch --show-current 2>/dev/null || echo "")
    GIT_REMOTE=$(git -C "$PROJECT_ROOT" remote get-url origin 2>/dev/null || echo "")
    GIT_STATUS=$(git -C "$PROJECT_ROOT" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    
    log "INFO: Git Branch: ${GIT_BRANCH:-detached}"
    log "INFO: Git Remote: ${GIT_REMOTE:-none}"
    log "INFO: Git Uncommitted Changes: ${GIT_STATUS:-0}"
fi

# === ENVIRONMENT CONTEXT ===
NODE_VERSION=""
PYTHON_VERSION=""
GO_VERSION=""
RUST_VERSION=""

case "$PROJECT_TYPE" in
    nodejs|react|vue|angular|nextjs)
        NODE_VERSION=$(node --version 2>/dev/null || echo "not installed")
        log "INFO: Node.js Version: $NODE_VERSION"
        ;;
    python)
        PYTHON_VERSION=$(python3 --version 2>/dev/null || python --version 2>/dev/null || echo "not installed")
        log "INFO: Python Version: $PYTHON_VERSION"
        ;;
    go)
        GO_VERSION=$(go version 2>/dev/null | awk '{print $3}' || echo "not installed")
        log "INFO: Go Version: $GO_VERSION"
        ;;
    rust)
        RUST_VERSION=$(rustc --version 2>/dev/null | awk '{print $2}' || echo "not installed")
        log "INFO: Rust Version: $RUST_VERSION"
        ;;
esac

# === WRITE CONTEXT CACHE ===
CONTEXT_FILE="$CONTEXT_CACHE/session-${SESSION_ID}.json"

cat > "$CONTEXT_FILE" << EOF
{
  "session_id": "$SESSION_ID",
  "timestamp": "$(date -Iseconds)",
  "project": {
    "name": "$PROJECT_NAME",
    "type": "$PROJECT_TYPE",
    "root": "$PROJECT_ROOT",
    "working_dir": "$WORKING_DIR"
  },
  "git": {
    "branch": "$GIT_BRANCH",
    "remote": "$GIT_REMOTE",
    "uncommitted_changes": $GIT_STATUS
  },
  "environment": {
    "node_version": "$NODE_VERSION",
    "python_version": "$PYTHON_VERSION",
    "go_version": "$GO_VERSION",
    "rust_version": "$RUST_VERSION"
  }
}
EOF

log "INFO: Context cached to: $CONTEXT_FILE"

# === CLEANUP OLD CONTEXT FILES (older than 7 days) ===
find "$CONTEXT_CACHE" -name "session-*.json" -mtime +7 -delete 2>/dev/null || true

log "INFO: Session initialization complete"
exit 0
