# Claude Code Subagents Analysis Summary

## Executive Summary
Subagents are specialized AI assistants operating in isolated contexts for specific tasks. They prevent context pollution while enabling parallel execution.

## Key Concepts
| Concept | Definition |
|---------|------------|
| Context Isolation | Each subagent has separate context window |
| Tool Inheritance | Can inherit all tools or be restricted |
| No Nesting | Subagents cannot spawn other subagents |
| Priority Order | Project > CLI > User level |

## Built-in Agent Types
1. **Plan** - Research and gather codebase info before planning
2. **Explore** - Fast, lightweight (Haiku), read-only
3. **General-Purpose** - Multi-step tasks with file modification

## Configuration Template
```yaml
---
name: agent-name
description: "When to invoke and what it does"
tools: Read, Grep, Glob, Bash
model: sonnet
---
System prompt defining role and approach
```

## Storage Locations
- User: `~/.claude/agents/`
- Project: `.claude/agents/`

## Best Practices
1. Single responsibility per agent
2. Least-privilege tool access
3. Use context early to preserve main context
4. Combine with CLAUDE.md for shared knowledge

## Anti-Patterns
- Allowing all tools → over-execution
- Context blindness → missing project context
- Over-engineering with too many custom agents
