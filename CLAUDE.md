# Claude Code Global Configuration

## System Overview

This is the central configuration hub for Claude Code, providing global settings, agent definitions, MCP server configurations, skills, and automation hooks that apply across all projects. This configuration enables sophisticated multi-agent orchestration, documentation intelligence, and continuous improvement workflows.

**Configuration Location:** `~/.claude/`
**Last Updated:** 2026-01-03

---

## Available Agents

Custom agents extend Claude Code's capabilities through specialized analysis and coordination tasks.

### Coordination Agents (Opus Model)

| Agent | File | Purpose | Trigger Phrases |
|-------|------|---------|-----------------|
| `orchestrator` | `~/.claude/agents/orchestrator.md` | Coordinate parallel agent execution | "full review", "comprehensive analysis" |
| `meta-orchestrator` | `~/.claude/agents/meta-orchestrator.md` | Multi-phase workflow coordination | "orchestrate", "multi-phase" |
| `edge-researcher` | `~/.claude/agents/edge-researcher.md` | Centralized intelligence coordinator | "research", "intelligence" |

### Documentation Intelligence Agents

| Agent | File | Model | Purpose | Trigger Phrases |
|-------|------|-------|---------|-----------------|
| `doc-overview` | `~/.claude/agents/doc-overview.md` | opus | Structure discovery & dependency mapping | "analyze docs", "map documentation" |
| `section-analyzer` | `~/.claude/agents/section-analyzer.md` | sonnet | Deep-dive section analysis | "analyze section" |
| `prompt-engineer` | `~/.claude/agents/prompt-engineer.md` | opus | Optimize agent prompts | "optimize prompts" |
| `consolidator` | `~/.claude/agents/consolidator.md` | opus | Cross-section synthesis | "consolidate findings" |
| `sop-generator` | `~/.claude/agents/sop-generator.md` | sonnet | Create SOPs from knowledge | "create SOPs" |

### Analysis Agents (Sonnet Model)

| Agent | File | Purpose | Trigger Phrases |
|-------|------|---------|-----------------|
| `security-auditor` | `~/.claude/agents/security-reviewer.md` | Security vulnerability analysis | "security review", "check vulnerabilities" |
| `performance-profiler` | `~/.claude/agents/performance-optimizer.md` | Performance bottleneck detection | "optimize", "performance review" |
| `test-coverage-analyst` | `~/.claude/agents/test-engineer.md` | Test coverage and generation | "write tests", "test coverage" |
| `api-contract-validator` | Custom agent | API contract validation | "validate API", "contract check" |
| `dependency-scanner` | Custom agent | Dependency vulnerability scanning | "scan dependencies", "check packages" |
| `documentation-writer` | `~/.claude/agents/documentation-writer.md` | Documentation creation | "document", "add docs" |
| `self-reviewer` | `~/.claude/agents/self-reviewer.md` | Quality self-assessment | "review your work", "check quality" |
| `system-analyzer` | `~/.claude/agents/system-analyzer.md` | System resource analysis | "system status", "resources" |

### Agent Model Preferences

| Agent Type | Model | Rationale |
|------------|-------|-----------|
| Orchestrators | opus | Complex coordination requires advanced reasoning |
| Analysis Agents | sonnet | Balanced speed and quality for focused tasks |
| Quick Exploration | haiku | Fast responses for simple queries |

---

## MCP Servers Reference

Model Context Protocol (MCP) servers extend Claude Code with external capabilities and data access.

**Configuration File:** `~/.claude/.mcp.json`

| Server | Package | Purpose | Required Environment |
|--------|---------|---------|---------------------|
| `filesystem` | `@modelcontextprotocol/server-filesystem` | File system access and operations | (auto-configured) |
| `memory` | `@modelcontextprotocol/server-memory` | Cross-session memory persistence | (none) |
| `git` | `@modelcontextprotocol/server-git` | Git repository operations | (none) |
| `github` | `@modelcontextprotocol/server-github` | GitHub API access (PRs, issues, actions) | `GITHUB_TOKEN` |
| `postgres` | `@modelcontextprotocol/server-postgres` | PostgreSQL database access | `POSTGRES_URL` |
| `fetch` | `@modelcontextprotocol/server-fetch` | HTTP requests and web fetching | (none) |
| `sequential-thinking` | `@modelcontextprotocol/server-sequential-thinking` | Complex multi-step reasoning | (none) |
| `neo4j` | `@neo4j/mcp-server-neo4j` | Knowledge graph database access | `NEO4J_URI`, `NEO4J_USER`, `NEO4J_PASSWORD` |

### Environment Setup

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# GitHub API access
export GITHUB_TOKEN="your-github-token"

# PostgreSQL connection
export POSTGRES_URL="postgresql://claude:claudecode123@localhost:5432/claude_intelligence"

# Neo4j connection
export NEO4J_URI="bolt://localhost:7687"
export NEO4J_USER="neo4j"
export NEO4J_PASSWORD="claudecode123"
```

### Verifying MCP Connections

```bash
# Test PostgreSQL
pg_isready -h localhost -p 5432 -U claude && echo "Postgres: OK"

# Test Neo4j
curl -s http://localhost:7474 && echo "Neo4j: OK"

# Validate MCP config syntax
cat ~/.claude/.mcp.json | jq .
```

---

## Skills Reference

Skills provide reusable workflows and templates for common operations.

**Skills Directory:** `~/.claude/skills/`

| Skill | Directory | Purpose |
|-------|-----------|---------|
| `pr-review-standards` | `~/.claude/skills/pr-review-standards/` | Standardized PR review workflows and checklists |
| `commit-message-generator` | `~/.claude/skills/commit-message-generator/` | Generate consistent, semantic commit messages |
| `api-documentation` | `~/.claude/skills/api-documentation/` | API documentation generation and formatting |
| `code-explanation` | `~/.claude/skills/code-explanation/` | Code explanation and annotation workflows |
| `parallel-orchestration` | `~/.claude/skills/parallel-orchestration/` | Multi-agent parallel execution patterns |
| `doc-intelligence` | `~/.claude/skills/doc-intelligence/` | Documentation analysis and SOP generation |

### Invoking Skills

```bash
# Use a skill in conversation
"Use the commit-message-generator skill for this change"

# Combine skills
"Apply pr-review-standards and security review before merge"
```

---

## Hooks Overview

Hooks enable automation at key execution points in Claude Code sessions.

**Configuration File:** `~/.claude/hooks/hooks.json`

### Hook Types

| Hook Event | Trigger Point | Common Uses |
|------------|---------------|-------------|
| `PreToolUse` | Before any tool execution | Validation, logging, confirmation prompts |
| `PostToolUse` | After tool execution completes | Quality checks, follow-up suggestions, logging |
| `Stop` | Before session/task completion | Final verification, summary generation |
| `SubagentStop` | When a subagent completes | Quality evaluation, result logging |
| `SessionStart` | At session initialization | Environment setup, context loading |

### Current Hook Configuration

```json
{
  "SessionStart": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "mkdir -p ~/.claude/logs && echo \"SESSION_START\" >> ~/.claude/logs/events.log"
        }
      ]
    }
  ],
  "PostToolUse": [
    {
      "matcher": "Edit|Write|MultiEdit",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "If this edit involves security-sensitive code, consider recommending the security-reviewer agent."
        }
      ]
    }
  ],
  "SubagentStop": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Evaluate the subagent's output for completeness and accuracy."
        }
      ]
    }
  ],
  "Stop": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Verify all requirements addressed before completing."
        }
      ]
    }
  ]
}
```

### Hook Matcher Patterns

| Pattern | Description |
|---------|-------------|
| `*` | Match all events |
| `Edit\|Write\|MultiEdit` | Match specific tools (OR logic) |
| `Task` | Match subagent launches |

---

## Quick Commands

### Orchestration Commands

| Command | Description |
|---------|-------------|
| `/orchestrate` | Launch full orchestration system |
| `/orchestrate status` | Check current system status |
| `/orchestrate parallel [task]` | Run task with maximum parallelization |
| `/orchestrate research [topic]` | Launch research workflow |
| `/orchestrate shutdown` | Gracefully stop all services |

### Common Operations

```bash
# Full code review
"Do a full review before I create the PR"

# Security-focused analysis
"Run security-auditor on the authentication code"

# Performance check
"Use performance-profiler on the database layer"

# Test coverage
"Run test-coverage-analyst to identify gaps"

# Documentation analysis
"Use doc-intelligence to analyze the API documentation"

# Self-assessment
"Run self-reviewer on the changes I just made"
```

### Infrastructure Management

```bash
# Deploy Docker services
docker-compose -f ~/ClaudeCode/docker-compose.yml up -d

# Check service status
docker-compose -f ~/ClaudeCode/docker-compose.yml ps

# View resource usage
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Stop services (preserves data)
docker-compose -f ~/ClaudeCode/docker-compose.yml down

# Clean restart (removes data)
docker-compose -f ~/ClaudeCode/docker-compose.yml down -v && docker-compose -f ~/ClaudeCode/docker-compose.yml up -d
```

---

## Security Guidelines

### Code Security Standards

| Standard | Requirement |
|----------|-------------|
| Credentials | Zero tolerance for hardcoded credentials |
| User Input | All user input must be validated |
| Database Queries | Use parameterized queries only |
| Authentication | Multi-factor recommended for sensitive operations |
| Secrets | Store in environment variables or secret managers |

### Automatic Security Triggers

The system automatically suggests `security-auditor` agent when detecting:
- Authentication/authorization code modifications
- Credential or token handling
- User input processing
- Database query construction
- API endpoint security configurations

### Security Review Workflow

```bash
# Quick security check
"Check if my login code is secure"

# Comprehensive security audit
"Run security-auditor with full depth analysis on the auth module"

# Pre-deployment security review
"Do a security review of all changes before deployment"
```

### Files to Never Commit

```
.env
.env.local
.env.production
credentials.json
secrets.yaml
*.pem
*.key
id_rsa*
```

---

## Performance Tips

### Agent Parallelization Capacity

| Resource Level | Recommended Agents | Tier |
|----------------|-------------------|------|
| < 8GB RAM | 3-5 parallel agents | Light |
| 8-16GB RAM | 5-10 parallel agents | Standard |
| > 16GB RAM | 10-20 parallel agents | Heavy |

### Optimization Strategies

1. **Use Tiered Execution**
   - Identify independent tasks (Tier 0)
   - Launch all Tier 0 agents simultaneously
   - Execute dependent tasks as prerequisites complete

2. **Leverage Caching**
   - Redis for session state and recent findings
   - PostgreSQL for persistent patterns and history
   - MinIO for large artifacts

3. **Monitor Resource Usage**
   ```bash
   # Check Docker resource consumption
   docker stats --no-stream

   # System resource overview
   top -l 1 | head -10
   ```

4. **Reduce Context Size**
   - Focus agents on specific files/directories
   - Use targeted prompts rather than broad analysis
   - Break large tasks into smaller parallel units

### Performance Standards

| Area | Threshold |
|------|-----------|
| Query Pagination | Always use LIMIT for database queries |
| N+1 Detection | Flag as high priority issue |
| Caching | Note missing opportunities |
| Report Confidence | Only report issues >= 80% confidence |

---

## File System Structure

```
~/.claude/
├── CLAUDE.md                    # This file - global configuration
├── .mcp.json                    # MCP server configurations
├── agents/                      # Custom agent definitions
│   ├── orchestrator.md
│   ├── meta-orchestrator.md
│   ├── edge-researcher.md
│   ├── system-analyzer.md
│   ├── security-reviewer.md
│   ├── performance-optimizer.md
│   ├── test-engineer.md
│   ├── documentation-writer.md
│   ├── self-reviewer.md
│   ├── doc-overview.md
│   ├── section-analyzer.md
│   ├── prompt-engineer.md
│   ├── consolidator.md
│   └── sop-generator.md
├── skills/                      # Reusable skill workflows
│   ├── parallel-orchestration/
│   ├── doc-intelligence/
│   ├── pr-review-standards/
│   ├── commit-message-generator/
│   ├── api-documentation/
│   └── code-explanation/
├── hooks/                       # Automation hooks
│   ├── hooks.json
│   └── scripts/
├── commands/                    # Custom slash commands
│   └── orchestrate.md
├── doc-intelligence/            # Documentation analysis outputs
│   ├── documentation-topology.md
│   ├── consolidated-intelligence.md
│   ├── section-analyses/
│   └── sops/
├── plugins/                     # Installed plugins
└── logs/                        # Event logs
    └── events.log

~/ClaudeCode/
├── docker-compose.yml           # Docker infrastructure
├── headquarters/                # Operations dashboard
├── plugins/                     # Project-specific plugins
├── workflows/                   # Workflow definitions
└── init-scripts/                # Database initialization
```

---

## Quick Start

### First Time Setup

```bash
# 1. Deploy infrastructure
docker-compose -f ~/ClaudeCode/docker-compose.yml up -d

# 2. Set environment variables (add to shell profile)
export POSTGRES_URL="postgresql://claude:claudecode123@localhost:5432/claude_intelligence"
export NEO4J_PASSWORD="claudecode123"
export GITHUB_TOKEN="your-token"

# 3. Verify services
docker-compose -f ~/ClaudeCode/docker-compose.yml ps

# 4. Start orchestration
/orchestrate
```

### Daily Workflow

```bash
# Check system status
/orchestrate status

# Launch parallel analysis
"Use edge-researcher to coordinate security and performance review"

# Research documentation
"Use doc-intelligence to analyze the MCP section"
```

### Continuous Improvement

After completing significant tasks:
1. Run `self-reviewer` agent for quality assessment
2. Note successful patterns for future reference
3. Record issues found for learning
4. Update relevant SOPs if new procedures are discovered

---

## Troubleshooting

### Docker Issues

```bash
# Check container logs
docker logs claude-neo4j
docker logs claude-postgres

# Restart specific service
docker-compose -f ~/ClaudeCode/docker-compose.yml restart neo4j

# Check network connectivity
docker network inspect claude-network
```

### MCP Connection Issues

```bash
# Test Neo4j
curl -s http://localhost:7474 && echo "Neo4j: OK"

# Test Postgres
pg_isready -h localhost -p 5432 -U claude && echo "Postgres: OK"

# Check MCP config syntax
cat ~/.claude/.mcp.json | jq .
```

### Resource Constraints

- Reduce parallel agent count
- Check Docker resource limits: `docker stats`
- Consider selective service shutdown
- Monitor with: `docker stats --no-stream`

---

**Version:** 2.0
**Maintained by:** Claude Code Configuration Expert
