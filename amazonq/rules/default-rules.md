Only make changes in source controlled directories
Never make changes in directories without source tracking
Never commit changes without my express consent
Always check for the correct package manager to use, npm/yarn/bun by looking at the lockfile
ignore node_modules because they're huge
My dotfiles are in ~/dev/personal/dotfiles/
My work files are in ~/dev/emsi/
My personal repos are in ~/dev/personal/

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
