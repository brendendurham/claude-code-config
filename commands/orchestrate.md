---
description: Launch the centralized orchestration system - initializes all infrastructure, assesses resources, and prepares for parallel multi-agent operations
allowed-tools: Bash, Read, Write, Task
---

# /orchestrate - Centralized Intelligence Orchestration

## Phase 1: Infrastructure Verification

First, verify all infrastructure is operational:

```bash
# Check Docker services
docker-compose -f ~/ClaudeCode/docker-compose.yml ps

# If not running, start them
docker-compose -f ~/ClaudeCode/docker-compose.yml up -d
```

## Phase 2: System Assessment

Launch the system-analyzer agent to gather complete system context:

"Use system-analyzer to provide a comprehensive assessment of:
- Hardware resources and capacity
- Running Docker services
- MCP server connectivity
- Available Claude Code extensions"

## Phase 3: Initialize Edge Researcher

With system context loaded, initialize the edge-researcher:

"The system analysis is complete. Now use edge-researcher to:
1. Load any previous session context from memory
2. Assess the current operational capacity
3. Report readiness for parallel multi-agent operations
4. Provide recommendations for the current session"

## Phase 4: Ready State

The orchestration system is now ready. You can:

1. **Run parallel analyses**: "Launch security, performance, and test agents in parallel"
2. **Conduct research**: "Use doc-intelligence to analyze [documentation]"
3. **Coordinate projects**: "Use edge-researcher to coordinate [project tasks]"
4. **Generate SOPs**: "Create SOPs for [workflow]"

## Quick Commands After Orchestration

- `/orchestrate status` - Check current system status
- `/orchestrate parallel [task]` - Run task with maximum parallelization
- `/orchestrate research [topic]` - Launch research workflow
- `/orchestrate shutdown` - Gracefully stop all services
