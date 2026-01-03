# Claude Code MCP Analysis Summary

## Executive Summary
MCP (Model Context Protocol) connects Claude to external tools via stdio, HTTP, or SSE transports. Supports flexible scoping and enterprise controls.

## Transport Types
| Type | Use Case | Best For |
|------|----------|----------|
| stdio | Local processes | Direct system access |
| HTTP | Remote servers | Cloud services (recommended) |
| SSE | Streaming | Real-time data |

## Configuration Template
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {"GITHUB_TOKEN": "${GITHUB_TOKEN}"}
    }
  }
}
```

## Scopes
- **user**: `~/.claude.json` - Personal, all projects
- **project**: `.mcp.json` - Team-shared, versioned
- **local**: `.claude/settings.local.json` - Personal, per-project

## Popular Servers
- filesystem, git, github, postgres
- memory, fetch, puppeteer, slack

## Enterprise Controls
- Allowlists/denylists for server restrictions
- `managed-mcp.json` for complete lockdown
- URL pattern matching for security

## Security Considerations
- 43% of MCP servers have command injection flaws
- Sanitize all inputs before shell execution
- Use environment variables for credentials
- Container isolation recommended
