# Memory Management Rules

## Solution-First Memory Search Rule
**CRITICAL RULE: ALWAYS search existing solutions BEFORE attempting any fixes or implementations**
- **MANDATORY FIRST STEP**: Check Solutions Index (`dotfiles/solutions-index`) for known problem patterns
- **MANDATORY SECOND STEP**: Search project-memory for related solution files using `list_project_files` and `memory_bank_read`
- **MANDATORY THIRD STEP**: Search graph-memory for problem/solution relationships using `aim_search_nodes`
- **MANDATORY FOURTH STEP**: Search sprint-memory for recent debugging sessions
- **ONLY THEN**: Attempt new solutions if no existing solution found
- **ALWAYS**: Update Solutions Index and create relationships when solving new problems
- **PREVENT**: Re-solving the same recurring issues multiple times

## Automatic Memory Storage Rules
- **MANDATORY: Store information by default rather than asking**
- **IMMEDIATELY** store any key learnings, debugging solutions, or configuration patterns discovered during sessions
- **ALWAYS** store debugging processes and solutions in sprint-memory for immediate reference
- **ALWAYS** store finalized configuration patterns and best practices in project-memory for long-term reference
- **ALWAYS** store relationships between tools, configurations, and processes in graph-memory
- **MUST** capture the context of WHY something works, not just WHAT works
- **MUST** include specific examples, error messages, and solutions in memory entries
- **MUST** tag entries with relevant keywords for easy retrieval
- **MANDATORY**: For any recurring problem, create a solution file and add it to Solutions Index
- **MANDATORY**: Link problems to solutions in graph-memory for quick discovery

## Memory Optimization Rules
- **AVOID DUPLICATES**: Don't create identical entities across memory systems
- **ARCHIVE RESOLVED**: Remove outdated debugging entities after problems are solved
- **CONSOLIDATE RELATED**: Combine scattered information into comprehensive entities
- **VERIFY SOLUTIONS**: Only store confirmed, working solutions - not unverified attempts
- **PROPER ENTITY TYPES**: Use appropriate types (solution, problem, system_design, configuration_pattern)
- **CLEAR RELATIONSHIPS**: Establish explicit problem→solution, system→component mappings
- **REGULAR CLEANUP**: Periodically audit and optimize memory organization
