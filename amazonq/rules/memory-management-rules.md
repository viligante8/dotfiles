# Memory Management Rules

## Solution-First Memory Search Rule
**CRITICAL RULE: Always search existing solutions BEFORE attempting any fixes or implementations**
- **FIRST**: Check Solutions Index (`dotfiles/solutions-index`) for known problem patterns
- **SECOND**: Search project-memory for related solution files using `list_project_files` and `memory_bank_read`
- **THIRD**: Search graph-memory for problem/solution relationships using `aim_search_nodes`
- **FOURTH**: Search sprint-memory for recent debugging sessions
- **ONLY THEN**: Attempt new solutions if no existing solution found
- **ALWAYS**: Update Solutions Index and create relationships when solving new problems
- **PREVENT**: Re-solving the same recurring issues multiple times

## Automatic Memory Storage Rules
- **DEFAULT TO REMEMBERING**: Store information by default rather than asking
- IMMEDIATELY store any key learnings, debugging solutions, or configuration patterns discovered during sessions
- Store debugging processes and solutions in sprint-memory for immediate reference
- Store finalized configuration patterns and best practices in project-memory for long-term reference
- Store relationships between tools, configurations, and processes in graph-memory
- Always capture the context of WHY something works, not just WHAT works
- Include specific examples, error messages, and solutions in memory entries
- Tag entries with relevant keywords for easy retrieval
- **CREATE SOLUTION ENTRIES**: For any recurring problem, create a solution file and add it to Solutions Index
- **ESTABLISH RELATIONSHIPS**: Link problems to solutions in graph-memory for quick discovery

## Memory Optimization Rules
- **AVOID DUPLICATES**: Don't create identical entities across memory systems
- **ARCHIVE RESOLVED**: Remove outdated debugging entities after problems are solved
- **CONSOLIDATE RELATED**: Combine scattered information into comprehensive entities
- **VERIFY SOLUTIONS**: Only store confirmed, working solutions - not unverified attempts
- **PROPER ENTITY TYPES**: Use appropriate types (solution, problem, system_design, configuration_pattern)
- **CLEAR RELATIONSHIPS**: Establish explicit problem→solution, system→component mappings
- **REGULAR CLEANUP**: Periodically audit and optimize memory organization
