# Claude Code Configuration

Versioned configuration for Claude Code following official documentation patterns. Provides agents, skills, hooks, and commands for multi-agent orchestration.

## Repository Structure

```
claude-code-config/
├── CLAUDE.md                 # Global Claude Code instructions
├── setup.sh                  # Symlink setup
│
├── agents/                   # 19 custom agent definitions
│   ├── orchestrator.md       # Parallel agent coordination
│   ├── meta-orchestrator.md  # Multi-phase workflow coordination
│   ├── edge-researcher.md    # Centralized intelligence coordinator
│   └── ...
│
├── skills/                   # 6 reusable workflow skills
│   ├── pr-review-standards/
│   ├── commit-message-generator/
│   └── ...
│
├── hooks/                    # Inline automation hooks
│   └── hooks.json            # All hooks with inline commands
│
├── commands/                 # Slash commands
│   └── orchestrate.md
│
├── doc-intelligence/         # Documentation analysis outputs
│   ├── section-analyses/
│   └── sops/
│
└── mcp/
    └── mcp.json.template
```

## Automation Patterns (Official)

Following Claude Code documentation, automation uses:

### 1. Inline Hook Commands
No external scripts - commands embedded in `hooks.json`:
```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "mkdir -p ~/.claude/logs && echo SESSION >> ~/.claude/logs/sessions.log"
      }]
    }]
  }
}
```

### 2. Background Bash Execution
Use `run_in_background: true` for parallel tasks - no script files needed.

### 3. Subagents for Parallel Work
Launch multiple Task tools simultaneously for parallel agent execution.

### 4. SessionStart with CLAUDE_ENV_FILE
Set environment variables without creating files:
```json
{
  "command": "if [ -n \"$CLAUDE_ENV_FILE\" ]; then echo 'export VAR=value' >> \"$CLAUDE_ENV_FILE\"; fi"
}
```

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| `orchestrator` | opus | Coordinate parallel agent execution |
| `meta-orchestrator` | opus | Multi-phase workflow coordination |
| `edge-researcher` | opus | Centralized intelligence coordinator |
| `security-auditor` | sonnet | Security vulnerability analysis |
| `performance-profiler` | sonnet | Performance bottleneck detection |
| `test-coverage-analyst` | sonnet | Test coverage and generation |
| `api-contract-validator` | sonnet | API contract validation |
| `dependency-scanner` | haiku | Fast dependency scanning |
| `documentation-writer` | sonnet | Documentation creation |
| `self-reviewer` | sonnet | Quality self-assessment |
| `system-analyzer` | sonnet | System resource analysis |
| `doc-overview` | opus | Documentation structure mapping |
| `section-analyzer` | sonnet | Deep-dive section analysis |
| `consolidator` | opus | Cross-section synthesis |
| `sop-generator` | sonnet | SOP creation |
| `prompt-engineer` | opus | Prompt optimization |

## Skills

| Skill | Purpose |
|-------|---------|
| `pr-review-standards` | Standardized PR review |
| `commit-message-generator` | Semantic commits |
| `api-documentation` | API docs formatting |
| `code-explanation` | Code annotation |
| `parallel-orchestration` | Multi-agent patterns |
| `doc-intelligence` | Documentation analysis |

## Hooks

All hooks use inline commands (no external scripts):

| Hook | Event | Purpose |
|------|-------|---------|
| `PreToolUse` | Before tool | Security validation |
| `PostToolUse` | After tool | Logging, review triggers |
| `Stop` | Task end | Completion verification |
| `SubagentStop` | Agent end | Quality check |
| `SessionStart` | Session start | Environment setup |

## Symlinks

```
~/.claude/agents           -> ~/claude-code-config/agents
~/.claude/skills           -> ~/claude-code-config/skills
~/.claude/hooks            -> ~/claude-code-config/hooks
~/.claude/commands         -> ~/claude-code-config/commands
~/.claude/doc-intelligence -> ~/claude-code-config/doc-intelligence
~/.claude/CLAUDE.md        -> ~/claude-code-config/CLAUDE.md
```

---

**Version:** 1.2.0
**License:** MIT
