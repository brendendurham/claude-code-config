#!/bin/bash
# Parallel Agent Launcher - Run multiple background processes
# Used by Claude to spawn parallel operations

set -e

LOG_DIR="$HOME/.claude/logs"
PIDS_FILE="$LOG_DIR/parallel-pids.txt"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date -Iseconds)] $1" | tee -a "$LOG_DIR/parallel.log"
}

# Start a background job
start_job() {
    local name="$1"
    local command="$2"
    local log_file="$LOG_DIR/${name}.log"

    # Run in background, capture PID
    ($command > "$log_file" 2>&1) &
    local pid=$!

    echo "$pid:$name" >> "$PIDS_FILE"
    log "Started job '$name' (PID: $pid)"
    echo $pid
}

# Wait for all jobs
wait_all() {
    if [ ! -f "$PIDS_FILE" ]; then
        log "No jobs to wait for"
        return 0
    fi

    local failed=0
    while IFS=: read -r pid name; do
        if wait $pid 2>/dev/null; then
            log "Job '$name' (PID: $pid) completed successfully"
        else
            log "Job '$name' (PID: $pid) failed"
            ((failed++))
        fi
    done < "$PIDS_FILE"

    rm -f "$PIDS_FILE"
    return $failed
}

# Check job status
status() {
    if [ ! -f "$PIDS_FILE" ]; then
        echo "No active jobs"
        return 0
    fi

    echo "Active jobs:"
    while IFS=: read -r pid name; do
        if ps -p $pid > /dev/null 2>&1; then
            echo "  [$pid] $name - RUNNING"
        else
            echo "  [$pid] $name - COMPLETED"
        fi
    done < "$PIDS_FILE"
}

# Kill all jobs
kill_all() {
    if [ ! -f "$PIDS_FILE" ]; then
        return 0
    fi

    while IFS=: read -r pid name; do
        if ps -p $pid > /dev/null 2>&1; then
            kill $pid 2>/dev/null && log "Killed job '$name' (PID: $pid)"
        fi
    done < "$PIDS_FILE"

    rm -f "$PIDS_FILE"
}

# Cleanup old logs
cleanup_logs() {
    find "$LOG_DIR" -name "*.log" -mtime +7 -delete 2>/dev/null
    log "Cleaned up old logs"
}

case "${1:-help}" in
    start)
        start_job "$2" "$3"
        ;;
    wait)
        wait_all
        ;;
    status)
        status
        ;;
    kill)
        kill_all
        ;;
    cleanup)
        cleanup_logs
        ;;
    *)
        echo "Usage: $0 {start|wait|status|kill|cleanup}"
        echo ""
        echo "Commands:"
        echo "  start <name> <command>  - Start a background job"
        echo "  wait                    - Wait for all jobs to complete"
        echo "  status                  - Show job status"
        echo "  kill                    - Kill all running jobs"
        echo "  cleanup                 - Remove old log files"
        ;;
esac
