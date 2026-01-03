# SOP-001: Create Custom Agent

## Metadata
- **ID:** SOP-001
- **Version:** 1.0
- **Complexity:** Simple
- **Time:** 5 minutes
- **Prerequisites:** None

## Objective
Create a custom subagent with specialized capabilities and tool restrictions.

## Procedure

### Phase 1: Setup

1. [ ] **Create agents directory**
   ```bash
   mkdir -p ~/.claude/agents  # User-level (all projects)
   # OR
   mkdir -p .claude/agents    # Project-level (team)
   ```

2. [ ] **Choose agent name** (kebab-case)
   - Example: `security-reviewer`, `test-engineer`

### Phase 2: Create Agent File

3. [ ] **Create markdown file with frontmatter**
   ```bash
   cat > ~/.claude/agents/my-agent.md << 'EOF'
   ---
   name: my-agent
   description: "Use this agent when [specific trigger]. It specializes in [capability]."
   tools: Read, Grep, Glob
   model: sonnet
   ---

   You are a specialized assistant for [purpose].

   ## Guidelines
   - Guideline 1
   - Guideline 2

   ## Output Format
   [Specify expected output structure]
   EOF
   ```

### Phase 3: Configure Tools

4. [ ] **Select appropriate tools**
   | Role | Recommended Tools |
   |------|-------------------|
   | Read-only | `Read, Grep, Glob` |
   | Code writer | `Read, Write, Edit, Bash, Glob, Grep` |
   | Research | `Read, Grep, Glob, WebFetch, WebSearch` |

5. [ ] **Optionally use /agents command** for interactive tool configuration

### Phase 4: Test

6. [ ] **Invoke agent in Claude Code**
   ```
   "Use my-agent to analyze this code"
   ```

7. [ ] **Verify isolated context** - agent operates separately from main conversation

## Success Criteria
- [ ] Agent file exists in correct location
- [ ] Frontmatter parses correctly
- [ ] Agent invokes when mentioned
- [ ] Tools are restricted as configured

## Rollback
```bash
rm ~/.claude/agents/my-agent.md
```
