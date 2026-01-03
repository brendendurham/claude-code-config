# Claude Code Configuration

A comprehensive, versioned configuration repository for Claude Code - Anthropic's official CLI tool for Claude. This repository provides agents, skills, hooks, commands, and documentation intelligence workflows for sophisticated multi-agent orchestration.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/brendendurham/claude-code-config.git ~/.claude-code-config

# Run the setup script to create symlinks
cd ~/.claude-code-config
./setup.sh
```

## Repository Structure

```
claude-code-config/
├── README.md                 # This file
├── CHANGELOG.md              # Version history
├── setup.sh                  # Installation/symlink script
├── CLAUDE.md                 # Global Claude Code instructions
│
├── agents/                   # Custom agent definitions
│   ├── orchestrator.md       # Parallel agent coordination
│   ├── meta-orchestrator.md  # Multi-phase workflow coordination
│   ├── edge-researcher.md    # Centralized intelligence coordinator
│   ├── doc-overview.md       # Documentation structure mapping
│   ├── section-analyzer.md   # Deep-dive section analysis
│   ├── consolidator.md       # Cross-section synthesis
│   ├── sop-generator.md      # SOP creation
│   ├── prompt-engineer.md    # Prompt optimization
│   ├── security-reviewer.md  # Security vulnerability analysis
│   ├── security-auditor.md   # Enterprise security audit
│   ├── performance-optimizer.md  # Performance optimization
│   ├── performance-profiler.md   # Enterprise performance profiling
│   ├── test-engineer.md      # Test generation
│   ├── test-coverage-analyst.md  # Test coverage analysis
│   ├── documentation-writer.md   # Documentation creation
│   ├── self-reviewer.md      # Quality self-assessment
│   ├── system-analyzer.md    # System resource analysis
│   ├── api-contract-validator.md # API contract validation
│   └── dependency-scanner.md # Dependency vulnerability scanning
│
├── skills/                   # Reusable skill workflows
│   ├── pr-review-standards/  # Standardized PR review
│   ├── commit-message-generator/  # Semantic commit messages
│   ├── api-documentation/    # API docs generation
│   ├── code-explanation/     # Code explanation workflows
│   ├── parallel-orchestration/   # Multi-agent patterns
│   └── doc-intelligence/     # Documentation analysis
│
├── hooks/                    # Automation hooks
│   ├── hooks.json            # Hook configuration
│   └── scripts/              # Hook scripts
│       ├── validate-write.sh # Write validation
│       ├── validate-bash.sh  # Bash command validation
│       └── load-context.sh   # Context loading
│
├── commands/                 # Custom slash commands
│   └── orchestrate.md        # /orchestrate command
│
├── doc-intelligence/         # Documentation analysis outputs
│   ├── documentation-topology.md
│   ├── consolidated-intelligence.md
│   ├── consolidation-template.md
│   ├── section-analyses/
│   │   ├── hooks.md
│   │   ├── mcp.md
│   │   ├── plugins.md
│   │   ├── skills.md
│   │   ├── subagents.md
│   │   └── headless-sdk.md
│   └── sops/
│       ├── SOP-001-create-custom-agent.md
│       └── SOP-002-parallel-orchestration.md
│
└── mcp/                      # MCP server configurations
    └── mcp.json.template     # Template (copy to ~/.claude/.mcp.json)
```

## Installation

### Prerequisites

- [Claude Code CLI](https://claude.ai/claude-code) installed
- Git
- Bash shell

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/brendendurham/claude-code-config.git ~/.claude-code-config
   ```

2. **Run the setup script:**
   ```bash
   cd ~/.claude-code-config
   chmod +x setup.sh
   ./setup.sh
   ```

   The setup script will:
   - Back up existing ~/.claude configuration
   - Create symlinks from ~/.claude to this repository
   - Set up the MCP configuration template

3. **Configure MCP servers (optional):**
   ```bash
   # Copy and edit the MCP template
   cp ~/.claude-code-config/mcp/mcp.json.template ~/.claude/.mcp.json

   # Add your environment variables to ~/.zshrc or ~/.bashrc
   export GITHUB_PERSONAL_ACCESS_TOKEN="your-token"
   export POSTGRES_URL="postgresql://user:pass@localhost:5432/db"
   ```

## Features

### Agents

Custom agents extend Claude Code with specialized capabilities:

| Agent | Model | Purpose |
|-------|-------|---------|
| `orchestrator` | opus | Coordinate parallel agent execution |
| `meta-orchestrator` | opus | Multi-phase workflow coordination |
| `edge-researcher` | opus | Centralized intelligence coordinator |
| `security-auditor` | sonnet | Enterprise security analysis |
| `performance-profiler` | sonnet | Performance bottleneck detection |
| `test-coverage-analyst` | sonnet | Test coverage and generation |
| `documentation-writer` | sonnet | Documentation creation |
| `self-reviewer` | sonnet | Quality self-assessment |

### Skills

Skills provide reusable workflows:

| Skill | Purpose |
|-------|---------|
| `pr-review-standards` | Standardized PR review checklists |
| `commit-message-generator` | Semantic commit message generation |
| `api-documentation` | API documentation formatting |
| `code-explanation` | Code annotation and explanation |
| `parallel-orchestration` | Multi-agent execution patterns |
| `doc-intelligence` | Documentation analysis workflows |

### Hooks

Automation hooks for event-driven workflows:

| Hook | Event | Purpose |
|------|-------|---------|
| `PreToolUse` | Before tool execution | Validation, logging |
| `PostToolUse` | After tool execution | Security review, metrics |
| `Stop` | Task completion | Verification |
| `SubagentStop` | Subagent completion | Quality validation |
| `SessionStart` | Session start | Context loading |

## Usage

### Orchestration Commands

```bash
# Launch full orchestration system
/orchestrate

# Check system status
/orchestrate status

# Run with maximum parallelization
/orchestrate parallel [task]
```

### Agent Invocation

```bash
# Security review
"Run security-auditor on the authentication module"

# Performance analysis
"Use performance-profiler on the database queries"

# Test coverage
"Run test-coverage-analyst to identify gaps"

# Documentation
"Use documentation-writer to update the API docs"
```

### Documentation Intelligence

```bash
# Analyze documentation
"Use doc-intelligence to analyze all documentation"

# Map structure
"Use doc-overview to map the documentation structure"

# Generate SOPs
"Create SOPs from the analysis results"
```

## Configuration

### CLAUDE.md

The `CLAUDE.md` file contains global instructions for Claude Code. It includes:

- Agent definitions and trigger phrases
- MCP server reference
- Skills documentation
- Hooks overview
- Security guidelines
- Performance tips
- Troubleshooting guide

### MCP Servers

Configure MCP servers by editing `~/.claude/.mcp.json`:

| Server | Purpose | Environment Variable |
|--------|---------|---------------------|
| `github` | GitHub API access | `GITHUB_PERSONAL_ACCESS_TOKEN` |
| `postgres` | PostgreSQL access | `POSTGRES_URL` |
| `memory` | Session persistence | - |
| `fetch` | HTTP requests | - |
| `sequential-thinking` | Complex reasoning | - |

## Updating

```bash
# Pull latest changes
cd ~/.claude-code-config
git pull origin main

# Re-run setup if structure changed
./setup.sh
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit changes: `git commit -m "Add my feature"`
4. Push to branch: `git push origin feature/my-feature`
5. Open a Pull Request

## License

MIT License - see LICENSE file for details.

## Version History

See [CHANGELOG.md](CHANGELOG.md) for version history and release notes.

---

**Maintained by:** Claude Code Configuration Expert
**Version:** 1.0.0
