# Utility Modules Unit Tests

This directory contains unit tests for the utility modules using the plenary.nvim test framework.

## Test Files

- `package-manager_spec.lua` - Tests for the package manager detection utility
- `package-scripts_spec.lua` - Tests for the package.json script parser utility  
- `picker_spec.lua` - Tests for the generic picker utility

## Running Tests

To run all tests:

```bash
cd ~/.dotfiles/nvim
nvim --headless -c "lua require('plenary.test_harness').test_directory('lua/utils/')"
```

To run a specific test file:

```bash
cd ~/.dotfiles/nvim
nvim --headless -c "lua require('plenary.test_harness').test_file('lua/utils/package-manager_spec.lua')"
```

## Test Coverage

The tests cover the following edge cases and scenarios:

### package-manager_spec.lua
- Detection of different package managers (bun, yarn, npm)
- Priority order (bun > yarn > npm > fallback)
- Handling of missing package files
- Directory path edge cases (with/without trailing slash)
- Non-existent directories
- Special characters in directory names

### package-scripts_spec.lua
- Missing package.json files
- Invalid JSON in package.json
- Empty scripts sections
- Scripts field with wrong data type
- Lifecycle script detection and filtering
- Debug script detection and filtering
- Pattern-based filtering (include/exclude)
- Category-based filtering
- Script categorization and sorting
- Parent directory traversal for package.json
- Null scripts handling

### picker_spec.lua
- Parameter validation (cwd, prompt, callback)
- Empty script list handling
- Pattern-based file filtering
- Custom format function support
- Integration with vim.ui.select fallback

## Requirements

- Neovim with plenary.nvim installed
- The utility modules must be properly loaded in your Neovim configuration

## Notes

- Tests use temporary directories under `/tmp/nvim_test_*` which are automatically cleaned up
- Some tests mock vim functions to isolate functionality
- The picker tests handle command execution edge cases that may occur in different shell environments
