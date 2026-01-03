#!/bin/bash
# Auto Runner - Execute commands autonomously with tmux parallelization
# This script handles its own execution and cleanup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SESSION_NAME="claude-auto"
LOG_DIR="$HOME/.claude/logs"

mkdir -p "$LOG_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[AUTO]${NC} $1"
    echo "[$(date -Iseconds)] $1" >> "$LOG_DIR/auto-runner.log"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    echo "[$(date -Iseconds)] ERROR: $1" >> "$LOG_DIR/auto-runner.log"
}

# Create tmux session if it doesn't exist
ensure_session() {
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux new-session -d -s "$SESSION_NAME" -n "main"
        log "Created tmux session: $SESSION_NAME"
    fi
}

# Run command in new tmux window
run_in_window() {
    local window_name="$1"
    local command="$2"
    local wait_for_completion="${3:-false}"

    ensure_session

    # Create window and run command
    tmux new-window -t "$SESSION_NAME" -n "$window_name" "$command; echo 'DONE'; sleep 2"
    log "Started: $window_name"

    if [ "$wait_for_completion" = "true" ]; then
        # Wait for window to close
        while tmux list-windows -t "$SESSION_NAME" 2>/dev/null | grep -q "$window_name"; do
            sleep 1
        done
        log "Completed: $window_name"
    fi
}

# Run multiple commands in parallel
run_parallel() {
    local -a commands=("$@")
    ensure_session

    for i in "${!commands[@]}"; do
        local cmd="${commands[$i]}"
        local window_name="parallel-$i"
        tmux new-window -t "$SESSION_NAME" -n "$window_name" "$cmd"
    done

    log "Launched ${#commands[@]} parallel tasks"
}

# Git operations
git_sync() {
    cd "$REPO_DIR"

    if [ -n "$(git status --porcelain)" ]; then
        git add -A
        git commit -m "Auto-sync: $(date +%Y-%m-%d_%H:%M:%S)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
        git push origin main
        log "Changes synced to GitHub"
    else
        log "No changes to sync"
    fi
}

# Full setup - no manual intervention
full_setup() {
    log "Starting full autonomous setup..."

    # 1. Ensure symlinks
    "$SCRIPT_DIR/../setup.sh"

    # 2. Sync to GitHub
    git_sync

    # 3. Verify installation
    verify_install

    log "Full setup complete"
}

# Verify installation
verify_install() {
    local errors=0

    # Check symlinks
    for item in agents skills hooks commands doc-intelligence CLAUDE.md; do
        if [ -L "$HOME/.claude/$item" ]; then
            log "✓ Symlink OK: $item"
        else
            error "✗ Missing symlink: $item"
            ((errors++))
        fi
    done

    # Check tmux
    if command -v tmux &>/dev/null; then
        log "✓ tmux available"
    else
        error "✗ tmux not found"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        log "All checks passed"
    else
        error "$errors issues found"
    fi

    return $errors
}

# Cleanup
cleanup() {
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux kill-session -t "$SESSION_NAME"
        log "Cleaned up tmux session"
    fi
}

# Self-delete after execution (for one-shot scripts)
self_destruct() {
    local script_path="$1"
    if [ -f "$script_path" ]; then
        rm -f "$script_path"
        log "Cleaned up temporary script: $script_path"
    fi
}

# Main dispatch
case "${1:-help}" in
    setup)
        full_setup
        ;;
    sync)
        git_sync
        ;;
    verify)
        verify_install
        ;;
    parallel)
        shift
        run_parallel "$@"
        ;;
    window)
        run_in_window "$2" "$3" "${4:-false}"
        ;;
    cleanup)
        cleanup
        ;;
    *)
        echo "Usage: $0 {setup|sync|verify|parallel|window|cleanup}"
        echo ""
        echo "Commands:"
        echo "  setup    - Full autonomous setup"
        echo "  sync     - Sync changes to GitHub"
        echo "  verify   - Verify installation"
        echo "  parallel - Run commands in parallel tmux windows"
        echo "  window   - Run command in named tmux window"
        echo "  cleanup  - Kill tmux session"
        ;;
esac
