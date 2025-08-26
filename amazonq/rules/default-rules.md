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

## Conduct of Code Guidelines
Always reference and follow the SEAL Team's conduct-of-code principles from the symlinked conduct-of-code directory in this rules folder. Before making any code changes or recommendations, read the relevant guidelines from these files to ensure all work aligns with the team's current standards. The conduct-of-code directory contains all current best practices and will automatically include any new guidelines added to the source.

You have access to four MCP servers:

1. metamcp: orchestrator/proxy that exposes all tools in a clear namespace. Use it to see available memory servers.
2. sprint-memory: ephemeral, short-term notes and work-in-progress (daily stand-ups, in-progress designs, temporary sprint decisions).
3. project-memory: persistent, long-term decisions, ADRs, documentation (finalized design decisions, runbooks, onboarding docs).
4. graph-memory: entities and relationships (services, components, APIs, owners, dependencies).

Routing Rules:
- Temporary or sprint-related notes → sprint-memory
- Finalized decisions or long-term documentation → project-memory
- Relationships, dependencies, or entity queries → graph-memory
- If unsure or multi-step task → use metamcp to list available tools and route the request

Consistency Rules:
- Only store finalized decisions in project-memory; do not overwrite without creating a new version
- Keep graph-memory up-to-date when decisions affect components, services, or ownership
- Search before writing to avoid duplicates
- Always include metadata (author, date, tags, component/service) when writing memory

Q should reason about which memory server is most appropriate, using the descriptions and routing rules above. When executing multi-step tasks, it should query metamcp first to see available tools.

Automatic Memory Storage Rules:
- IMMEDIATELY store any key learnings, debugging solutions, or configuration patterns discovered during sessions
- Store debugging processes and solutions in sprint-memory for immediate reference
- Store finalized configuration patterns and best practices in project-memory for long-term reference
- Store relationships between tools, configurations, and processes in graph-memory
- Always capture the context of WHY something works, not just WHAT works
- Include specific examples, error messages, and solutions in memory entries
- Tag entries with relevant keywords for easy retrieval
