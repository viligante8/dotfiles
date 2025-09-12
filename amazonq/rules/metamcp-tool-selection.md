# MetaMCP Tool Selection Rules

## Automatic Tool Selection Rule
**CRITICAL RULE: Never require users to explicitly specify which tools to use**
- Automatically analyze requests and select appropriate tools based on content and complexity
- Use MetaMCP namespace routing for direct tool selection (development/infrastructure/documentation/memory)
- For complex or multi-step requests, use `sequential-thinking___sequentialthinking` to plan approach
- Follow the detailed workflow documented in `dotfiles/automatic-tool-selection-workflow.md`
- Simple requests → Direct namespace routing
- Complex requests → Sequential thinking + multiple tools + result storage
- Always follow: Memory search → Complexity assessment → Tool execution → Result storage

## Sequential Thinking Integration
**MANDATORY: Use `sequential-thinking___sequentialthinking` for EVERY REQUEST**
- **ALWAYS START** with sequential thinking to assess complexity and requirements
- **NO EXCEPTIONS** - even simple requests need reasoning to determine if they're actually simple
- **REQUIRED FOR ALL**: Single commands, multi-step problems, debugging, analysis, questions
- **REASONING FIRST**: Only through structured thinking can you determine what other tools are needed

**Sequential thinking is the gateway to:**
- Determining if memory search is needed
- Assessing true complexity vs apparent simplicity  
- Choosing appropriate tools and workflows
- Preventing assumption-based responses

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

## Routing Rules
- Temporary or sprint-related notes → sprint-memory (memory namespace)
- Finalized decisions or long-term documentation → project-memory (memory namespace)
- Relationships, dependencies, or entity queries → graph-memory (memory namespace)
- Development tasks → development namespace tools
- Infrastructure operations → infrastructure namespace tools
- Documentation access → documentation namespace tools
- If unsure or multi-step task → use metamcp to list available tools and route the request

## Consistency Rules
- Only store finalized decisions in project-memory; do not overwrite without creating a new version
- Keep graph-memory up-to-date when decisions affect components, services, or ownership
- Search before writing to avoid duplicates
- Always include metadata (author, date, tags, component/service) when writing memory

Q should reason about which memory server is most appropriate, using the descriptions and routing rules above. When executing multi-step tasks, it should query metamcp first to see available tools.
