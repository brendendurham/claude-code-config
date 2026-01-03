#!/bin/bash
# Claude Code Configuration Setup Script
# Creates symlinks and installs hooks configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude-backup-$(date +%Y%m%d_%H%M%S)"

echo "==================================="
echo "Claude Code Configuration Setup"
echo "==================================="
echo ""
echo "Repository: $SCRIPT_DIR"
echo "Target: $CLAUDE_DIR"
echo ""

# Create ~/.claude if needed
mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/logs"

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"

    if [ ! -e "$source" ]; then
        echo "  SKIP: $source does not exist"
        return
    fi

    # Backup if exists and not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "  Backing up: $target"
        cp -r "$target" "$BACKUP_DIR/" 2>/dev/null || true
    fi

    # Remove existing
    rm -rf "$target" 2>/dev/null || true

    # Create symlink
    ln -s "$source" "$target"
    echo "  $target -> $source"
}

echo "Creating symlinks..."

# Create symlinks for versioned content
create_symlink "$SCRIPT_DIR/agents" "$CLAUDE_DIR/agents"
create_symlink "$SCRIPT_DIR/skills" "$CLAUDE_DIR/skills"
create_symlink "$SCRIPT_DIR/commands" "$CLAUDE_DIR/commands"
create_symlink "$SCRIPT_DIR/doc-intelligence" "$CLAUDE_DIR/doc-intelligence"
create_symlink "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

echo ""
echo "Installing hooks configuration..."

# Install settings.json (hooks) - copy, don't symlink (user may customize)
if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
    if [ -f "$SCRIPT_DIR/settings.json.template" ]; then
        cp "$SCRIPT_DIR/settings.json.template" "$CLAUDE_DIR/settings.json"
        echo "  Created: $CLAUDE_DIR/settings.json"
    fi
else
    echo "  EXISTS: $CLAUDE_DIR/settings.json (not overwriting)"
fi

echo ""
echo "==================================="
echo "Setup Complete!"
echo "==================================="
echo ""

# Run verification
if [ -x "$SCRIPT_DIR/verify.sh" ]; then
    echo "Running verification..."
    echo ""
    "$SCRIPT_DIR/verify.sh"
fi

echo ""
echo "NOTE: Hooks take effect on NEXT session start."
echo ""

if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    echo "Backup created at: $BACKUP_DIR"
fi
