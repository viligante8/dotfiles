# Codex Agent Rules

Modular rules that guide Codex CLI behavior. Load these as resources in your agent config so they apply to every session.

## Rule Categories
- Basic Development Rules — source control, package managers, directories
- Documentation‑First Approach — consult docs and examples before actions
- Solution Verification — never claim success until the user confirms
- Context Rule Enforcement — read rules, search memory, then act
- MCP Tool Selection — use namespaces and plan before tool calls
- Memory Management — search/write project and graph memories

## Usage
Reference these files via `file://codex/rules/**/*.md` in `resources`. Keep them small, explicit, and easy to revise.

