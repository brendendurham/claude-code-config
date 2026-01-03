# Claude Code Configuration

Test-driven, verified configuration for Claude Code. All hooks are tested and logged.

## Architecture

```
claude-code-config/           # Versioned in GitHub
├── settings.json.template    # Hooks config (copied to ~/.claude/settings.json)
├── verify.sh                 # Verification test suite
├── setup.sh                  # Installation script
├── agents/                   # 19 custom agents
├── skills/                   # 6 workflow skills
├── commands/                 # Slash commands
└── doc-intelligence/         # Analysis outputs

~/.claude/                    # Runtime location
├── settings.json             # Hooks (from template)
├── logs/
│   └── audit.log             # Hook execution log
├── agents -> repo/agents     # Symlink
├── skills -> repo/skills     # Symlink
├── commands -> repo/commands # Symlink
└── CLAUDE.md -> repo/CLAUDE.md
```

## Installation

```bash
git clone https://github.com/brendendurham/claude-code-config.git ~/claude-code-config
cd ~/claude-code-config
./setup.sh
```

Setup will:
1. Create symlinks for agents, skills, commands
2. Copy `settings.json.template` to `~/.claude/settings.json`
3. Run verification tests

## Verification

Run anytime to check configuration:

```bash
~/claude-code-config/verify.sh
```

Output:
```
1. settings.json exists: PASS
2. settings.json valid JSON: PASS
3. Hooks structure correct: PASS
4. Audit log exists (hooks firing): PASS
5. Agents directory: PASS (19 agents)
6. Skills directory: PASS (6 skills)
7. Commands directory: PASS (1 commands)
```

## Hooks (in settings.json)

All hooks log to `~/.claude/logs/audit.log`:

| Hook | Trigger | Action |
|------|---------|--------|
| `SessionStart` | Session begins | Log session start |
| `PreToolUse` | Before Write/Edit | Block hardcoded credentials |
| `PreToolUse` | Before Bash | Block dangerous commands |
| `PostToolUse` | After any tool | Log tool execution |
| `SubagentStop` | Agent completes | Log agent completion |
| `Stop` | Session ends | Log session end |

### Testing Hooks

Hooks load at session start. After installing, start a NEW session and check:

```bash
cat ~/.claude/logs/audit.log
```

Should show:
```
[2026-01-03T15:50:00-06:00] SESSION_START pid=12345 cwd=/path
[2026-01-03T15:50:01-06:00] PRE Bash ALLOWED
[2026-01-03T15:50:01-06:00] POST tool=Bash exit=0
```

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| `orchestrator` | opus | Parallel agent coordination |
| `meta-orchestrator` | opus | Multi-phase workflows |
| `edge-researcher` | opus | Intelligence coordination |
| `security-auditor` | sonnet | Security analysis |
| `performance-profiler` | sonnet | Performance analysis |
| `test-coverage-analyst` | sonnet | Test coverage |
| `self-reviewer` | sonnet | Quality review |
| + 12 more | | |

## Skills

| Skill | Purpose |
|-------|---------|
| `pr-review-standards` | PR review checklists |
| `commit-message-generator` | Semantic commits |
| `api-documentation` | API docs |
| `code-explanation` | Code annotation |
| `parallel-orchestration` | Multi-agent patterns |
| `doc-intelligence` | Doc analysis |

## Key Files

| File | Purpose |
|------|---------|
| `settings.json.template` | Hooks configuration template |
| `verify.sh` | Test suite for configuration |
| `setup.sh` | Installation script |
| `CLAUDE.md` | Global instructions |

---

**Version:** 2.0.0
**License:** MIT
