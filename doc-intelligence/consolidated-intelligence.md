# Consolidated Documentation Intelligence

## Executive Summary

This document synthesizes findings from 6 parallel section analyses of the Claude Code "Build with Claude Code" documentation. The analysis reveals a cohesive extensibility ecosystem where **Subagents** provide specialized execution, **Skills** provide domain knowledge, **Hooks** provide automation triggers, **MCP** provides external connectivity, **Plugins** bundle everything for distribution, and **Headless/SDK** enables programmatic control.

---

## Cross-Section Integration Map

```
┌─────────────────────────────────────────────────────────────────────┐
│                     CLAUDE CODE ECOSYSTEM                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐          │
│   │  SUBAGENTS  │────▶│   SKILLS    │────▶│   PLUGINS   │          │
│   │ (Execution) │     │ (Knowledge) │     │  (Bundle)   │          │
│   └──────┬──────┘     └──────┬──────┘     └──────┬──────┘          │
│          │                   │                   │                  │
│          ▼                   ▼                   ▼                  │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐          │
│   │    HOOKS    │────▶│     MCP     │────▶│   SDK/CLI   │          │
│   │(Automation) │     │(Connectivity)│    │(Programmatic)│          │
│   └─────────────┘     └─────────────┘     └─────────────┘          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Unified Terminology

| Term | Definition | Sections |
|------|------------|----------|
| **Subagent** | Delegated executor in isolated context | Subagents, SDK |
| **Skill** | Auto-activating domain knowledge bundle | Skills, Plugins |
| **Hook** | Event-driven automation trigger | Hooks, Plugins |
| **MCP Server** | External tool connector via protocol | MCP, Plugins |
| **Plugin** | Distributable extension package | Plugins, Skills, Hooks |
| **Frontmatter** | YAML configuration header in markdown | Skills, Agents, Commands |
| **Matcher** | Pattern for filtering hook events | Hooks |
| **Session** | Persistent conversation context | SDK, Hooks |

---

## Feature Synergy Matrix

| Combination | Capability | SOP |
|-------------|------------|-----|
| Subagents + Skills | Specialized agents with domain knowledge | SOP-101 |
| Subagents + Hooks | Automated agent quality gates | SOP-102 |
| Skills + Plugins | Distributable domain expertise | SOP-103 |
| Hooks + MCP | External tool automation triggers | SOP-104 |
| Plugins + MCP | Bundled external integrations | SOP-105 |
| SDK + Hooks | CI/CD automation pipelines | SOP-201 |
| SDK + Subagents | Programmatic multi-agent orchestration | SOP-202 |

---

## Crystallized Insights

### 1. Progressive Disclosure is Universal
**Pattern:** Load minimal context first, expand as needed
- Skills: Metadata → SKILL.md → References
- Agents: Description → Full prompt → Tools
- MCP: Server definition → Tool discovery → Execution

### 2. Configuration Hierarchy is Consistent
**Pattern:** Project > User > Defaults
- Applies to: Agents, Skills, Hooks, MCP, Plugins
- Enables team sharing with personal overrides

### 3. Markdown + YAML Frontmatter is Standard
**Pattern:** All definitions use markdown with YAML headers
- Agents: `---\nname: ...\n---`
- Skills: `---\nname: ...\n---`
- Commands: `---\ndescription: ...\n---`

### 4. Tool Restriction is Critical
**Pattern:** Least-privilege access across all components
- Agents: `tools:` field limits available tools
- Skills: `allowed-tools:` restricts capabilities
- Hooks: `matcher:` filters which tools trigger

### 5. Hooks Enable Deterministic Control
**Pattern:** Use hooks for what LLM shouldn't "remember"
- Security: Block dangerous commands
- Quality: Auto-format, lint, test
- Context: Inject environment info

### 6. Plugins are the Distribution Primitive
**Pattern:** Bundle everything in plugins for sharing
- Commands + Agents + Skills + Hooks + MCP
- Marketplace for discovery
- Version control for updates

---

## Decision Framework

### When to Use Subagents
```
Need isolated context? → Subagent
Need specialized expertise? → Subagent with Skills
Need parallel execution? → Multiple Subagents
Simple task delegation? → Task tool (clone pattern)
```

### When to Use Skills
```
Domain-specific knowledge? → Skill
Reusable procedures? → Skill with scripts
Auto-activation needed? → Skill (description triggers)
Manual only? → Skill with disable-model-invocation
```

### When to Use Hooks
```
Before tool execution? → PreToolUse hook
After file change? → PostToolUse hook
Quality gate at end? → Stop hook
Context injection? → SessionStart hook
Permission control? → PermissionRequest hook
```

### When to Use MCP
```
Need external data? → MCP server
Need database access? → MCP (postgres, etc.)
Need browser control? → MCP (puppeteer)
Team-wide integration? → Project-scope MCP
```

### When to Use SDK
```
CI/CD automation? → SDK/Headless
Production system? → SDK with hooks
Multi-turn workflows? → SDK with sessions
Custom permission logic? → SDK callbacks
```

---

## Anti-Pattern Registry

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| All tools on agents | Over-execution, context pollution | Explicit tool list |
| Nested subagents | Not supported, fails | Flat orchestration |
| Unbounded skill loading | Memory bloat | Progressive disclosure |
| Hardcoded paths | Breaks on install | Use `${CLAUDE_PLUGIN_ROOT}` |
| Unvalidated hook input | Security risk | Always validate stdin |
| HTTP MCP without auth | Data exposure | Use headers/env vars |
| Stop hooks without limits | Infinite loops | Add termination conditions |

---

## Integration Patterns

### Pattern 1: Full-Stack Review System
```
Plugins → Agents (security, performance, quality)
       → Skills (coding standards, patterns)
       → Hooks (auto-format, quality gates)
       → MCP (issue tracker, CI status)
```

### Pattern 2: CI/CD Pipeline
```
SDK Headless → Hooks (validation)
            → Subagents (parallel analysis)
            → MCP (GitHub, Sentry)
            → JSON output for parsing
```

### Pattern 3: Team Development Kit
```
Plugin Marketplace → Commands (workflows)
                  → Skills (team standards)
                  → Agents (specialized reviewers)
                  → Hooks (team policies)
```

---

## Knowledge Gaps Identified

1. **Cross-agent communication** - No direct inter-subagent messaging
2. **Skill dependencies** - Skills can't declare other skills as prerequisites
3. **Hook chaining** - Complex hook sequences require external orchestration
4. **MCP server health** - No built-in health checking for MCP servers

---

## Recommended SOPs to Generate

| SOP ID | Title | Priority |
|--------|-------|----------|
| SOP-001 | Create Custom Agent | High |
| SOP-002 | Create Custom Skill | High |
| SOP-003 | Configure Hooks for Quality | High |
| SOP-004 | Set Up MCP Server | Medium |
| SOP-005 | Create Plugin Package | Medium |
| SOP-101 | Parallel Agent Orchestration | High |
| SOP-102 | Quality Gate Pipeline | High |
| SOP-201 | CI/CD Integration | Medium |
| SOP-202 | Multi-Agent Workflow | High |
