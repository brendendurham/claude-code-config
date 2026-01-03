# Claude Code Documentation Topology

## Documentation Structure

**Base URL:** https://code.claude.com/docs/en/

## Build with Claude Code - Section Analysis Targets

| Section | URL | Tier | Dependencies | Complexity |
|---------|-----|------|--------------|------------|
| Subagents | /sub-agents | 1 | Overview, Common Workflows | High |
| Create Plugins | /plugins | 1.5 | Subagents, Skills, Hooks | High |
| Discover Plugins | /discover-plugins | 1 | Plugins (basic) | Medium |
| Agent Skills | /skills | 1 | Overview | Medium |
| Output Styles | /output-styles | 1 | Overview | Low |
| Hooks Guide | /hooks-guide | 1.5 | Overview, CLI Reference | Medium |
| Hooks Reference | /hooks | 2 | Hooks Guide | High |
| Programmatic Use | /headless | 1.5 | CLI Reference | High |
| MCP | /mcp | 1.5 | Overview, Settings | High |
| Troubleshooting | /troubleshooting | 0 | None | Low |

## Parallelization Strategy

### Tier 0 (Independent - Launch Immediately)
- Troubleshooting
- Output Styles (soft dependency only)

### Tier 1 (After Tier 0)
- Subagents
- Agent Skills
- Discover Plugins

### Tier 1.5 (After Tier 1)
- Create Plugins (requires: Subagents, Skills, Hooks)
- Hooks Guide
- Programmatic Use (Headless)
- MCP

### Tier 2 (After Tier 1.5)
- Hooks Reference (full API)
- Plugins Reference

## Dependency Graph

```
Overview (Tier 0)
    ├── Skills (Tier 1)
    │   └── Plugins (Tier 1.5)
    │       └── Plugins Reference (Tier 2)
    ├── Output Styles (Tier 1)
    ├── Subagents (Tier 1)
    │   └── Plugins (Tier 1.5)
    └── Settings (Tier 0.5)
        └── MCP (Tier 1.5)

CLI Reference (Tier 0)
    ├── Hooks Guide (Tier 1.5)
    │   └── Hooks Reference (Tier 2)
    └── Headless/Programmatic (Tier 1.5)
```

## Agent Assignments

| Section | Agent Focus | Key Extraction |
|---------|-------------|----------------|
| Subagents | Custom agent creation patterns | YAML config, delegation, built-in agents |
| Plugins | Plugin development workflow | Structure, manifest, commands |
| Skills | Skill definition patterns | SKILL.md format, invocation triggers |
| Hooks | Event-driven automation | Event types, handlers, security |
| MCP | External tool integration | Server config, resources |
| Headless | Programmatic automation | SDK patterns, JSON mode |
