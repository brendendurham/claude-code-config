#!/bin/bash
# Claude Code Configuration Verification Script
# Run this to check if hooks and configuration are working

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CLAUDE_DIR="$HOME/.claude"
LOGS_DIR="$CLAUDE_DIR/logs"
RESULTS=()

echo "========================================"
echo "Claude Code Configuration Verification"
echo "========================================"
echo ""

# Test 1: Check settings.json exists
echo -n "1. settings.json exists: "
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo -e "${GREEN}PASS${NC}"
    RESULTS+=("settings_exists:PASS")
else
    echo -e "${RED}FAIL${NC} - Copy settings.json.template to ~/.claude/settings.json"
    RESULTS+=("settings_exists:FAIL")
fi

# Test 2: Validate JSON syntax
echo -n "2. settings.json valid JSON: "
if [ -f "$CLAUDE_DIR/settings.json" ] && jq . "$CLAUDE_DIR/settings.json" > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    RESULTS+=("settings_valid:PASS")
else
    echo -e "${RED}FAIL${NC}"
    RESULTS+=("settings_valid:FAIL")
fi

# Test 3: Check hooks structure
echo -n "3. Hooks structure correct: "
if [ -f "$CLAUDE_DIR/settings.json" ] && jq -e '.hooks.SessionStart' "$CLAUDE_DIR/settings.json" > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}"
    RESULTS+=("hooks_structure:PASS")
else
    echo -e "${RED}FAIL${NC}"
    RESULTS+=("hooks_structure:FAIL")
fi

# Test 4: Check if audit.log exists (proves hooks are firing)
echo -n "4. Audit log exists (hooks firing): "
if [ -f "$LOGS_DIR/audit.log" ]; then
    LAST_ENTRY=$(tail -1 "$LOGS_DIR/audit.log" 2>/dev/null || echo "")
    if [ -n "$LAST_ENTRY" ]; then
        echo -e "${GREEN}PASS${NC}"
        echo "   Last entry: $LAST_ENTRY"
        RESULTS+=("hooks_firing:PASS")
    else
        echo -e "${YELLOW}WARN${NC} - Log exists but empty"
        RESULTS+=("hooks_firing:WARN")
    fi
else
    echo -e "${YELLOW}PENDING${NC} - Start a new session to test"
    RESULTS+=("hooks_firing:PENDING")
fi

# Test 5: Check agents directory
echo -n "5. Agents directory: "
if [ -d "$CLAUDE_DIR/agents" ]; then
    AGENT_COUNT=$(ls "$CLAUDE_DIR/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${GREEN}PASS${NC} ($AGENT_COUNT agents)"
    RESULTS+=("agents:PASS")
else
    echo -e "${RED}FAIL${NC}"
    RESULTS+=("agents:FAIL")
fi

# Test 6: Check skills directory
echo -n "6. Skills directory: "
if [ -d "$CLAUDE_DIR/skills" ]; then
    SKILL_COUNT=$(find "$CLAUDE_DIR/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${GREEN}PASS${NC} ($SKILL_COUNT skills)"
    RESULTS+=("skills:PASS")
else
    echo -e "${RED}FAIL${NC}"
    RESULTS+=("skills:FAIL")
fi

# Test 7: Check commands directory
echo -n "7. Commands directory: "
if [ -d "$CLAUDE_DIR/commands" ]; then
    CMD_COUNT=$(ls "$CLAUDE_DIR/commands"/*.md 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${GREEN}PASS${NC} ($CMD_COUNT commands)"
    RESULTS+=("commands:PASS")
else
    echo -e "${YELLOW}WARN${NC} - No commands"
    RESULTS+=("commands:WARN")
fi

# Summary
echo ""
echo "========================================"
echo "Summary"
echo "========================================"

PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

for result in "${RESULTS[@]}"; do
    status="${result#*:}"
    case "$status" in
        PASS) ((PASS_COUNT++)) ;;
        FAIL) ((FAIL_COUNT++)) ;;
        *) ((WARN_COUNT++)) ;;
    esac
done

echo -e "Passed: ${GREEN}$PASS_COUNT${NC}"
echo -e "Failed: ${RED}$FAIL_COUNT${NC}"
echo -e "Warnings: ${YELLOW}$WARN_COUNT${NC}"

# Write results to file
mkdir -p "$LOGS_DIR"
{
    echo "{"
    echo "  \"timestamp\": \"$(date -Iseconds)\","
    echo "  \"passed\": $PASS_COUNT,"
    echo "  \"failed\": $FAIL_COUNT,"
    echo "  \"warnings\": $WARN_COUNT,"
    echo "  \"results\": {"
    first=true
    for result in "${RESULTS[@]}"; do
        name="${result%:*}"
        status="${result#*:}"
        [ "$first" = "true" ] || echo ","
        first=false
        echo -n "    \"$name\": \"$status\""
    done
    echo ""
    echo "  }"
    echo "}"
} > "$LOGS_DIR/verify-results.json"

echo ""
echo "Results saved to: $LOGS_DIR/verify-results.json"

if [ "$FAIL_COUNT" -gt 0 ]; then
    exit 1
fi
