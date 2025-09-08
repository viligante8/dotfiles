# Amazon Q CLI Rules

This directory contains rules that guide Amazon Q's behavior when using the CLI chat interface. These rules are automatically loaded and applied to all conversations.

## Rule Categories

### [Basic Development Rules](./basic-development-rules.md)
- Source control requirements
- Package manager detection
- Directory structure conventions

### [Documentation-First Approach](./documentation-first-approach.md)
- Always check documentation before attempting solutions
- Use official examples and patterns
- Document discovered limitations

### [Solution Verification Rules](./solution-verification-rules.md)
- Never claim solutions are "fixed" until user confirms
- Wait for explicit verification
- Store failed attempts to avoid repetition

### [MetaMCP Tool Selection](./metamcp-tool-selection.md)
- Automatic tool selection without user specification
- Namespace routing patterns
- Complexity detection and sequential thinking triggers

### [Memory Management Rules](./memory-management-rules.md)
- Solution-first search patterns
- Automatic memory storage guidelines
- Three-tier memory architecture usage

### [Conduct of Code](./conduct-of-code/)
- Symlinked team standards and best practices
- Current development guidelines
- Code quality requirements

## Usage

These rules are automatically applied to all Amazon Q CLI conversations. The modular structure allows for easy maintenance and updates to specific rule categories without affecting others.

## Location

This directory is symlinked to `~/.aws/amazonq/rules/` following AWS CLI configuration conventions while maintaining version control in dotfiles.
