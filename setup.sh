#!/bin/bash
# Claude Code Configuration Setup Script
# Creates symlinks from ~/.claude to this repository

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

# Check if ~/.claude exists
if [ -d "$CLAUDE_DIR" ]; then
    echo "Existing ~/.claude directory found."
    echo ""

    # Check if already symlinked
    if [ -L "$CLAUDE_DIR/agents" ] && [ "$(readlink "$CLAUDE_DIR/agents")" = "$SCRIPT_DIR/agents" ]; then
        echo "Already configured. Updating symlinks..."
    else
        echo "Creating backup at: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"

        # Backup existing directories that we'll replace
        for dir in agents skills hooks commands doc-intelligence; do
            if [ -d "$CLAUDE_DIR/$dir" ] && [ ! -L "$CLAUDE_DIR/$dir" ]; then
                echo "  Backing up $dir..."
                cp -r "$CLAUDE_DIR/$dir" "$BACKUP_DIR/" 2>/dev/null || true
            fi
        done

        # Backup CLAUDE.md if it exists and isn't a symlink
        if [ -f "$CLAUDE_DIR/CLAUDE.md" ] && [ ! -L "$CLAUDE_DIR/CLAUDE.md" ]; then
            echo "  Backing up CLAUDE.md..."
            cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP_DIR/" 2>/dev/null || true
        fi

        echo "Backup complete."
    fi
else
    echo "Creating ~/.claude directory..."
    mkdir -p "$CLAUDE_DIR"
fi

echo ""
echo "Creating symlinks..."

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"

    # Remove existing file/directory/symlink
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi

    # Create symlink
    ln -s "$source" "$target"
    echo "  $target -> $source"
}

# Create symlinks for directories
create_symlink "$SCRIPT_DIR/agents" "$CLAUDE_DIR/agents"
create_symlink "$SCRIPT_DIR/skills" "$CLAUDE_DIR/skills"
create_symlink "$SCRIPT_DIR/hooks" "$CLAUDE_DIR/hooks"
create_symlink "$SCRIPT_DIR/commands" "$CLAUDE_DIR/commands"
create_symlink "$SCRIPT_DIR/doc-intelligence" "$CLAUDE_DIR/doc-intelligence"

# Create symlink for CLAUDE.md
create_symlink "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

echo ""
echo "Making hook scripts executable..."
chmod +x "$SCRIPT_DIR/hooks/scripts/"*.sh 2>/dev/null || true

echo ""
echo "==================================="
echo "Setup Complete!"
echo "==================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Configure MCP servers (optional):"
echo "   cp $SCRIPT_DIR/mcp/mcp.json.template ~/.claude/.mcp.json"
echo "   # Then edit ~/.claude/.mcp.json with your settings"
echo ""
echo "2. Set environment variables in ~/.zshrc or ~/.bashrc:"
echo "   export GITHUB_PERSONAL_ACCESS_TOKEN=\"your-token\""
echo "   export POSTGRES_URL=\"postgresql://user:pass@localhost:5432/db\""
echo ""
echo "3. Verify installation:"
echo "   ls -la ~/.claude/"
echo ""

if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    echo "Note: Your original configuration was backed up to:"
    echo "  $BACKUP_DIR"
    echo ""
fi

echo "For more information, see README.md"
