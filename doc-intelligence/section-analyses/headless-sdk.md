# Claude Code Programmatic Use / Headless Documentation Analysis

## Executive Summary

Claude Code provides robust programmatic capabilities through two primary interfaces: the **CLI headless mode** (via `-p` flag) and the **Agent SDK** (Python/TypeScript). These interfaces enable non-interactive automation, CI/CD integration, and production-grade agent development.

**Key Capabilities:**
- Non-interactive execution with JSON structured output
- Session persistence and resumption for multi-turn workflows
- Fine-grained tool permissions and approval callbacks
- Built-in tools: Read, Write, Edit, Bash, Glob, Grep, WebSearch, WebFetch
- Subagent delegation for complex task decomposition
- Hook system for custom behavior injection

## Key Concepts

| Concept | Definition | Importance |
|---------|------------|------------|
| Headless Mode | Non-interactive execution via `-p` flag | Critical for automation |
| JSON Output | Structured response with `--output-format json` | High for parsing |
| Session ID | Unique identifier for conversation continuity | High for multi-turn |
| Agent SDK | Python/TypeScript libraries for programmatic control | High for production |
| Tool Permissions | Granular control via `--allowedTools` | Critical for security |

## Core CLI Patterns

```bash
# Basic non-interactive
claude -p "Summarize this project"

# With JSON output
claude -p "command" --output-format json | jq '.result'

# Multi-turn with session
session=$(claude -p "Start" --output-format json | jq -r '.session_id')
claude -p "Continue" --resume "$session" --output-format json
```

## SDK Integration

```python
# Python SDK
from claude_agent_sdk import query, ClaudeAgentOptions

async for message in query(
    prompt="Task",
    options=ClaudeAgentOptions(allowed_tools=["Read", "Edit"])
):
    if hasattr(message, "result"):
        print(message.result)
```

```typescript
// TypeScript SDK
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Task",
  options: { allowedTools: ["Read", "Edit"] }
})) {
  if ("result" in message) console.log(message.result);
}
```

## CI/CD Template

```yaml
# GitHub Actions
- name: Claude Analysis
  run: |
    claude -p "Review changes" --output-format json | tee review.json
```

## Integration Points

- **Requires:** CLI Reference (commands/flags)
- **Enables:** CI/CD automation, Production agents, Custom workflows
- **Synergies:** Hooks (automation triggers), Subagents (task delegation)

## Actionable Takeaways

1. Use `--output-format json` for all automation scripts
2. Store session IDs for multi-turn workflow recovery
3. Minimize tool permissions with `--allowedTools`
4. Use SDK for production applications needing hooks/subagents
5. Implement timeout handling for long-running tasks
