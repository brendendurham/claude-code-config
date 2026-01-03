# Claude Code Configuration

A comprehensive, versioned configuration repository for Claude Code. Provides agents, skills, hooks, commands, and documentation intelligence workflows for sophisticated multi-agent orchestration.

**All operations are autonomous** - Claude handles setup, updates, and synchronization automatically.

## Repository Structure

```
claude-code-config/
├── CLAUDE.md                 # Global Claude Code instructions
├── setup.sh                  # Auto-setup with symlinks
│
├── agents/                   # 19 custom agent definitions
│   ├── orchestrator.md       # Parallel agent coordination
│   ├── meta-orchestrator.md  # Multi-phase workflow coordination
│   ├── edge-researcher.md    # Centralized intelligence coordinator
│   ├── security-auditor.md   # Enterprise security audit
│   ├── performance-profiler.md   # Performance analysis
│   ├── test-coverage-analyst.md  # Test coverage analysis
│   └── ...                   # 13 more specialized agents
│
├── skills/                   # 6 reusable workflow skills
│   ├── pr-review-standards/
│   ├── commit-message-generator/
│   ├── parallel-orchestration/
│   └── ...
│
├── hooks/                    # Automation hooks
│   ├── hooks.json            # Hook configuration
│   └── scripts/              # Validation scripts
│
├── commands/                 # Slash commands
│   └── orchestrate.md        # /orchestrate
│
├── scripts/                  # Automation scripts
│   ├── auto-runner.sh        # Autonomous execution
│   ├── parallel-agents.sh    # Background job management
│   └── exec-and-delete.sh    # One-shot script runner
│
├── doc-intelligence/         # Documentation analysis outputs
│   ├── section-analyses/
│   └── sops/
│
└── mcp/                      # MCP server configurations
    └── mcp.json.template
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
| `pr-review-standards` | Standardized PR review checklists |
| `commit-message-generator` | Semantic commit message generation |
| `api-documentation` | API documentation formatting |
| `code-explanation` | Code annotation and explanation |
| `parallel-orchestration` | Multi-agent execution patterns |
| `doc-intelligence` | Documentation analysis workflows |

## Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| `PreToolUse` | Before tool execution | Validation, security checks |
| `PostToolUse` | After tool execution | Security review, metrics |
| `Stop` | Task completion | Final verification |
| `SubagentStop` | Subagent completion | Quality validation |
| `SessionStart` | Session start | Context loading |

## Automation Scripts

### auto-runner.sh
Autonomous execution with tmux parallelization:
- `setup` - Full autonomous setup
- `sync` - Sync changes to GitHub
- `verify` - Verify installation
- `parallel` - Run commands in parallel
- `cleanup` - Kill tmux session

### parallel-agents.sh
Background job management:
- `start <name> <cmd>` - Start background job
- `wait` - Wait for all jobs
- `status` - Show job status
- `kill` - Kill all jobs

## Symlink Architecture

```
~/.claude/agents        -> ~/claude-code-config/agents
~/.claude/skills        -> ~/claude-code-config/skills
~/.claude/hooks         -> ~/claude-code-config/hooks
~/.claude/commands      -> ~/claude-code-config/commands
~/.claude/doc-intelligence -> ~/claude-code-config/doc-intelligence
~/.claude/CLAUDE.md     -> ~/claude-code-config/CLAUDE.md
```

All changes sync bidirectionally - edit in either location.

## MCP Servers

| Server | Purpose |
|--------|---------|
| `github` | GitHub API access |
| `postgres` | PostgreSQL database |
| `memory` | Session persistence |
| `fetch` | HTTP requests |
| `sequential-thinking` | Complex reasoning |
| `git` | Git operations |
| `filesystem` | File system access |

---

**Version:** 1.1.0
**License:** MIT
