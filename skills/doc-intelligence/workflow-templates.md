# Documentation Intelligence Workflow Templates

## Template 1: Full Documentation Scan

### Trigger
"Analyze [documentation source] completely"

### Execution Plan
```yaml
operation: full_documentation_scan
phases:
  - phase: 0
    name: discovery
    agents:
      - type: doc-overview
        input: "[documentation URL or path]"
        output: topology_map

  - phase: 1
    name: tier_0_analysis
    parallel: true
    max_concurrent: 20
    agents:
      - type: section-analyzer
        for_each: topology_map.tier_0_sections
        output: section_analysis[]

  - phase: 2
    name: tier_1_analysis
    parallel: true
    depends_on: [phase_1]
    agents:
      - type: section-analyzer
        for_each: topology_map.tier_1_sections
        output: section_analysis[]

  - phase: 3
    name: tier_n_analysis
    parallel: true
    repeat_until: all_tiers_complete
    agents:
      - type: section-analyzer
        for_each: topology_map.tier_n_sections
        output: section_analysis[]

  - phase: 4
    name: prompt_optimization
    depends_on: [all_analyses]
    agents:
      - type: prompt-engineer
        input: all_section_analyses
        output: optimized_prompts

  - phase: 5
    name: consolidation
    depends_on: [phase_4]
    agents:
      - type: consolidator
        input: all_section_analyses
        output: consolidated_intelligence

  - phase: 6
    name: sop_generation
    depends_on: [phase_5]
    parallel: true
    agents:
      - type: sop-generator
        for_each: consolidated_intelligence.workflows
        output: sops[]

outputs:
  - topology_map
  - section_analyses
  - optimized_prompts
  - consolidated_intelligence
  - sops
```

## Template 2: Targeted Section Analysis

### Trigger
"Analyze [specific section] in depth"

### Execution Plan
```yaml
operation: targeted_section_analysis
phases:
  - phase: 0
    name: section_discovery
    agents:
      - type: doc-overview
        input: "[section path]"
        scope: single_section
        output: section_structure

  - phase: 1
    name: subsection_analysis
    parallel: true
    agents:
      - type: section-analyzer
        for_each: section_structure.subsections
        output: subsection_analysis[]

  - phase: 2
    name: consolidation
    agents:
      - type: consolidator
        input: subsection_analyses
        scope: single_section
        output: section_intelligence

outputs:
  - section_structure
  - subsection_analyses
  - section_intelligence
```

## Template 3: SOP-Focused Scan

### Trigger
"Create SOPs for [workflow/topic]"

### Execution Plan
```yaml
operation: sop_focused_scan
phases:
  - phase: 0
    name: workflow_discovery
    agents:
      - type: doc-overview
        focus: workflow_identification
        input: "[documentation source]"
        output: workflow_map

  - phase: 1
    name: workflow_analysis
    parallel: true
    agents:
      - type: section-analyzer
        focus: procedural_content
        for_each: workflow_map.relevant_sections
        output: procedural_analysis[]

  - phase: 2
    name: sop_generation
    parallel: true
    agents:
      - type: sop-generator
        for_each: procedural_analyses
        output: sops[]

outputs:
  - workflow_map
  - procedural_analyses
  - sops
```

## Template 4: Continuous Learning Update

### Trigger
"Update knowledge from [new documentation]"

### Execution Plan
```yaml
operation: continuous_learning_update
phases:
  - phase: 0
    name: change_detection
    agents:
      - type: doc-overview
        mode: diff
        input: "[new docs]"
        compare_to: existing_topology
        output: change_report

  - phase: 1
    name: changed_section_analysis
    parallel: true
    agents:
      - type: section-analyzer
        for_each: change_report.modified_sections
        output: updated_analyses[]

  - phase: 2
    name: incremental_consolidation
    agents:
      - type: consolidator
        mode: incremental
        input: updated_analyses
        merge_with: existing_intelligence
        output: updated_intelligence

  - phase: 3
    name: sop_update
    agents:
      - type: sop-generator
        mode: update
        input: updated_intelligence
        existing_sops: current_sops
        output: updated_sops

outputs:
  - change_report
  - updated_analyses
  - updated_intelligence
  - updated_sops
```

## Template 5: Maximum Parallelization Benchmark

### Trigger
"Maximize parallel documentation analysis"

### Execution Plan
```yaml
operation: max_parallel_benchmark
config:
  max_concurrent_agents: 20
  parallelization_strategy: aggressive

phases:
  - phase: 0
    name: rapid_discovery
    agents:
      - type: doc-overview
        mode: fast
        output: quick_topology

  - phase: 1
    name: bulk_parallel_analysis
    parallel: true
    max_concurrent: 20
    strategy: fill_capacity
    agents:
      - type: section-analyzer
        for_each: quick_topology.all_sections
        priority_by: independence_score
        output: analyses[]

  - phase: 2
    name: rapid_consolidation
    agents:
      - type: consolidator
        mode: streaming
        input: analyses_as_available
        output: live_intelligence

metrics:
  - agents_utilized
  - parallel_efficiency
  - time_to_completion
  - throughput_sections_per_minute
```

## Dependency Specification Format

```yaml
dependencies:
  section_a:
    type: independent
    tier: 0

  section_b:
    type: hard_dependency
    requires: [section_a]
    tier: 1

  section_c:
    type: soft_dependency
    enhanced_by: [section_a]
    tier: 0  # Can start immediately

  section_d:
    type: hard_dependency
    requires: [section_b, section_c]
    tier: 2
```

## Progress Tracking Schema

```yaml
progress:
  operation_id: "doc-intel-20260103-001"
  started_at: "2026-01-03T12:00:00Z"
  current_phase: 2
  total_phases: 6

  agents:
    total: 25
    active: 15
    complete: 8
    failed: 0
    queued: 2

  sections:
    total: 20
    analyzed: 12
    in_progress: 5
    pending: 3

  efficiency:
    parallel_utilization: 0.75
    estimated_completion: "2026-01-03T12:45:00Z"

  artifacts:
    generated: 12
    pending: 8
```
