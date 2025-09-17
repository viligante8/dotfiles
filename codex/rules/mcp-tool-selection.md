# MCP Tool Selection Rules

## Automatic Tool Selection
- Analyze the request and pick tools without asking the user to name them.
- Route via namespaces (e.g., `development___tool`, `documentation___tool`, `infrastructure___tool`, `memory___tool`).
- For complex tasks, start with a sequential thinking step to plan.

## Planning First
- Begin with reasoning to assess complexity and required tools.
- Decide whether to read docs, search memory, or act immediately.

## Routing Guidance
- Temporary debug notes → sprint‑memory
- Finalized decisions/patterns → project‑memory
- Relationships/queries → graph‑memory
- Dev ops → infrastructure; Docs/search → documentation; General helpers → development/utilities

## Consistency
- Store only confirmed, final info in project‑memory.
- Keep graph‑memory in sync with decisions and relationships.
- Search before writing to avoid duplicates; include metadata and tags.

