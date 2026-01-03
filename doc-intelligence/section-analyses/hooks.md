# Claude Code Hooks Analysis Summary

## Executive Summary
Hooks enable deterministic control through shell commands at lifecycle points. Supports Command Hooks (bash) and Prompt Hooks (LLM evaluation).

## Hook Events
| Event | Can Block | Use Case |
|-------|-----------|----------|
| PreToolUse | Yes | Block dangerous commands, validate inputs |
| PostToolUse | No | Auto-format, type check |
| UserPromptSubmit | Yes | Inject context, validate prompts |
| Stop | Yes | Quality gates before completion |
| SubagentStop | Yes | Validate subagent output |
| SessionStart | No | Load context, set environment |
| SessionEnd | No | Cleanup, save state |
| PermissionRequest | Yes | Auto-approve/deny |

## Configuration Template
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{"type": "command", "command": "script.sh"}]
    }],
    "Stop": [{
      "hooks": [{"type": "prompt", "prompt": "Check completion"}]
    }]
  }
}
```

## Exit Codes
- **0**: Success, process JSON output
- **2**: Blocking error, stop execution
- **1,3+**: Non-blocking, continue

## Matcher Patterns
- `"Bash"` - Exact match
- `"Edit|Write"` - OR pattern
- `"*"` - All tools
- `"mcp__server__tool"` - MCP tools

## Security Best Practices
1. Always quote shell variables
2. Use absolute paths
3. Block dangerous operations
4. Protect sensitive files
