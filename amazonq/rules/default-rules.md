Only make changes in source controlled directories
Never make changes in directories without source tracking
Never commit changes without my express consent
Always check for the correct package manager to use, npm/yarn/bun by looking at the lockfile
ignore node_modules because they're huge
My dotfiles are in ~/dev/personal/dotfiles/
My work files are in ~/dev/emsi/
My personal repos are in ~/dev/personal/

## Documentation-First Approach
**CRITICAL RULE: Always check documentation and examples BEFORE attempting to use any tool or service**
- For MCP tools: Use available documentation functions specific to each tool (e.g., `get_diagram_examples` for diagrams, help functions, etc.)
- For AWS services: Use AWS documentation search tools FIRST
- For GitHub repositories: Use `fetch_generic_documentation`, `search_generic_documentation`, or `fetch_generic_url_content` FIRST
- For any unfamiliar tool: Search for official documentation, examples, or usage patterns FIRST
- Never guess or use trial-and-error when documentation is available
- Always reference working examples and official patterns before creating custom implementations
- Document any discovered limitations or patterns in working memory for future reference

## Solution Verification Rule
**CRITICAL RULE: Never consider a fix or solution resolved until the user explicitly verifies it works**
- Always state that solutions are "proposed" or "should resolve" rather than "fixed" or "resolved"
- Wait for user confirmation before marking issues as complete
- If a solution fails, acknowledge the failure and iterate on the approach
- Store attempted solutions in memory to avoid repeating failed approaches
- Only claim success after user verification

## Conduct of Code Guidelines
Always reference and follow the SEAL Team's conduct-of-code principles from the symlinked conduct-of-code directory in this rules folder. Before making any code changes or recommendations, read the relevant guidelines from these files to ensure all work aligns with the team's current standards. The conduct-of-code directory contains all current best practices and will automatically include any new guidelines added to the source.

You have access to four MCP servers through metamcp:

1. **metamcp**: orchestrator/proxy that exposes all tools through organized namespaces
2. **sprint-memory**: ephemeral, short-term notes and work-in-progress (daily stand-ups, in-progress designs, temporary sprint decisions)
3. **project-memory**: persistent, long-term decisions, ADRs, documentation (finalized design decisions, runbooks, onboarding docs)
4. **graph-memory**: entities and relationships (services, components, APIs, owners, dependencies)

## MetaMCP Namespace Organization
MetaMCP organizes MCP servers into **4 main namespaces**:

- **development**: Development tools (git, utilities, clipboard management)
- **documentation**: Documentation and knowledge access (git docs, AWS knowledge, fetch tools)
- **infrastructure**: Infrastructure and cloud operations (AWS API, Terraform, database, diagrams)
- **memory**: Memory and knowledge management systems (sprint-memory, project-memory, graph-memory)

## Best Practices for MetaMCP Usage
- **Use namespaced tool names**: Tools are accessed as `namespace___tool_name` (e.g., `memory___aim_create_entities`)
- **Route by purpose**: Choose the appropriate namespace based on the task type
- **Leverage aggregation**: MetaMCP aggregates multiple MCP servers, so you can access diverse tools through a single endpoint
- **Check tool availability**: Use metamcp to list available tools and their namespaces before making assumptions

Routing Rules:
- Temporary or sprint-related notes → sprint-memory (memory namespace)
- Finalized decisions or long-term documentation → project-memory (memory namespace)
- Relationships, dependencies, or entity queries → graph-memory (memory namespace)
- Development tasks → development namespace tools
- Infrastructure operations → infrastructure namespace tools
- Documentation access → documentation namespace tools
- If unsure or multi-step task → use metamcp to list available tools and route the request

Consistency Rules:
- Only store finalized decisions in project-memory; do not overwrite without creating a new version
- Keep graph-memory up-to-date when decisions affect components, services, or ownership
- Search before writing to avoid duplicates
- Always include metadata (author, date, tags, component/service) when writing memory

Q should reason about which memory server is most appropriate, using the descriptions and routing rules above. When executing multi-step tasks, it should query metamcp first to see available tools.

## Solution-First Memory Search Rule
**CRITICAL RULE: Always search existing solutions BEFORE attempting any fixes or implementations**
- **FIRST**: Check Solutions Index (`dotfiles/solutions-index`) for known problem patterns
- **SECOND**: Search project-memory for related solution files using `list_project_files` and `memory_bank_read`
- **THIRD**: Search graph-memory for problem/solution relationships using `aim_search_nodes`
- **FOURTH**: Search sprint-memory for recent debugging sessions
- **ONLY THEN**: Attempt new solutions if no existing solution found
- **ALWAYS**: Update Solutions Index and create relationships when solving new problems
- **PREVENT**: Re-solving the same recurring issues multiple times

Automatic Memory Storage Rules:
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

Memory Optimization Rules:
- **AVOID DUPLICATES**: Don't create identical entities across memory systems
- **ARCHIVE RESOLVED**: Remove outdated debugging entities after problems are solved
- **CONSOLIDATE RELATED**: Combine scattered information into comprehensive entities
- **VERIFY SOLUTIONS**: Only store confirmed, working solutions - not unverified attempts
- **PROPER ENTITY TYPES**: Use appropriate types (solution, problem, system_design, configuration_pattern)
- **CLEAR RELATIONSHIPS**: Establish explicit problem→solution, system→component mappings
- **REGULAR CLEANUP**: Periodically audit and optimize memory organization
