# SOP-202: Multi-Agent Parallel Orchestration

## Metadata
- **ID:** SOP-202
- **Version:** 1.0
- **Complexity:** Advanced
- **Time:** 10-15 minutes setup
- **Prerequisites:** Custom agents created

## Objective
Execute multiple specialized agents in parallel and synthesize results.

## Procedure

### Phase 1: Define Orchestration Request

1. [ ] **Identify parallelizable tasks**
   - Security review
   - Performance analysis
   - Test coverage
   - Documentation check

2. [ ] **Prepare orchestration prompt**
   ```
   "Launch the following agents in parallel:
   1. security-reviewer: Review authentication code for vulnerabilities
   2. performance-optimizer: Analyze database query performance
   3. test-engineer: Identify test coverage gaps

   Synthesize all findings into a prioritized report."
   ```

### Phase 2: Execute Parallel Analysis

3. [ ] **Use Task tool pattern**
   - Claude will invoke multiple Task tool calls in single response
   - Each agent runs in isolated context
   - Results collected asynchronously

4. [ ] **Monitor progress**
   - Use `/tasks` command to view running agents
   - Background agents continue while you work

### Phase 3: Synthesize Results

5. [ ] **Consolidate findings**
   - Deduplicate overlapping issues
   - Prioritize by severity (Critical > High > Medium > Low)
   - Note conflicting recommendations

6. [ ] **Generate unified report**
   ```
   ## Orchestrated Analysis Report

   ### Executive Summary
   [Key findings across all dimensions]

   ### Critical Issues
   [From all agents]

   ### Recommendations
   [Prioritized action items]
   ```

## Parallelization Patterns

### Pattern A: Fan-Out/Fan-In
```
Main → [Agent1, Agent2, Agent3] → Consolidate → Report
```

### Pattern B: Phased Parallel
```
Phase 1: [Explore1, Explore2] →
Phase 2: [Design1, Design2] →
Phase 3: Implement →
Phase 4: [Review1, Review2]
```

### Pattern C: Continuous Review
```
Every Edit → [AutoFormat] →
Stop → [QualityGate] →
Complete → [FinalReview]
```

## Success Criteria
- [ ] Multiple agents launched in parallel
- [ ] All agents complete successfully
- [ ] Results synthesized without duplicates
- [ ] Actionable report generated

## Troubleshooting
| Issue | Solution |
|-------|----------|
| Agent timeout | Check tool permissions |
| Missing results | Use TaskOutput to retrieve |
| Duplicate findings | Consolidation step needed |
