# Claude Code Agent Skills Documentation Analysis

## Executive Summary

Agent Skills are modular, self-contained packages that extend Claude's capabilities with specialized knowledge, workflows, and tool integrations. They function as "onboarding guides" for specific domains using a **progressive disclosure** architecture that loads context only when needed.

Key architectural principles:
- **Model-invoked**: Claude autonomously decides which skills to use
- **Progressive disclosure**: Metadata → SKILL.md → References (load as needed)
- **Filesystem-based**: Skills are directories enabling version control

## SKILL.md Template

```yaml
---
name: my-skill-name
description: Clear description with trigger terms
version: "1.0.0"
allowed-tools: Read, Write, Bash  # Optional tool restrictions
---

# My Skill Name

## Quick Start
[Essential steps with code examples]

## Guidelines
- Guideline 1
- Guideline 2

## Advanced
- **Feature A**: See [FEATURE_A.md](references/FEATURE_A.md)
```

## Directory Structure

```
skill-name/
├── SKILL.md              # Required: Main instructions
├── scripts/              # Executable Python/Bash
├── references/           # Documentation loaded as needed
└── assets/               # Templates, logos, fonts
```

## Key Concepts

| Concept | Definition | Importance |
|---------|------------|------------|
| Progressive Disclosure | 3-level loading (metadata → SKILL.md → references) | High |
| Trigger Description | Semantic matching for auto-invocation | Critical |
| allowed-tools | Tool restriction in frontmatter | Medium |
| {baseDir} | Portable path resolution | High |

## Distribution Options

1. **Project**: `.claude/skills/` (team via git)
2. **User**: `~/.claude/skills/` (personal cross-project)
3. **Marketplace**: `/plugin marketplace add` + `/plugin install`
4. **SDK**: `setting_sources=["user", "project"]`

## Best Practices

1. Keep SKILL.md under 500 lines
2. Use imperative form ("Analyze code for...")
3. Include specific trigger terms in descriptions
4. Use progressive disclosure patterns
5. Restrict tools with `allowed-tools` when appropriate
6. Use `{baseDir}` for portable paths

## Integration Points

- **Requires:** Overview (concepts)
- **Enables:** Plugins (bundled skills), Subagents (attached skills)
- **Synergies:** MCP (tool skills), Hooks (automation skills)
