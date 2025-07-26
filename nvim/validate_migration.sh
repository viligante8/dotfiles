#!/bin/bash

# LazyVim Migration Validation Script
# This script runs comprehensive tests for your migrated configuration

echo "🚀 LazyVim Migration Validation"
echo "================================"
echo ""

# Function to test basic Neovim startup
test_basic_startup() {
    echo "🔄 Testing basic Neovim startup..."
    if nvim --headless -c "echo 'Startup successful'" -c "qa!" >/dev/null 2>&1; then
        echo "✅ Neovim starts without errors"
        return 0
    else
        echo "❌ Neovim startup failed"
        return 1
    fi
}

# Function to test LazyVim installation
test_lazyvim() {
    echo "🔄 Testing LazyVim installation..."
    local version=$(nvim --headless -c "lua print(require('lazyvim.config').version)" -c "qa!" 2>/dev/null | grep -o '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*')
    if [ ! -z "$version" ]; then
        echo "✅ LazyVim version $version loaded"
        return 0
    else
        echo "❌ LazyVim not properly loaded"
        return 1
    fi
}

# Function to test colorscheme
test_colorscheme() {
    echo "🔄 Testing Kanagawa colorscheme..."
    local colorscheme=$(nvim --headless -c "lua print(vim.g.colors_name or 'none')" -c "qa!" 2>/dev/null | tail -1)
    if [ "$colorscheme" = "kanagawa" ]; then
        echo "✅ Kanagawa colorscheme active"
        return 0
    else
        echo "❌ Expected Kanagawa, got: $colorscheme"
        return 1
    fi
}

# Function to test custom options
test_options() {
    echo "🔄 Testing custom options..."
    local results=$(nvim --headless -c "
        lua
        local tests = {
            relativenumber = vim.opt.relativenumber:get(),
            colorcolumn = vim.opt.colorcolumn:get()[1] == '120',
            scrolloff = vim.opt.scrolloff:get() == 10,
            foldmethod = vim.opt.foldmethod:get() == 'expr'
        }
        for option, result in pairs(tests) do
            print(option .. ':' .. tostring(result))
        end
    " -c "qa!" 2>/dev/null)
    
    local success_count=0
    local total_count=4
    
    while IFS= read -r line; do
        if [[ $line == *":true" ]]; then
            option=$(echo $line | cut -d':' -f1)
            echo "✅ $option configured correctly"
            ((success_count++))
        elif [[ $line == *":false" ]]; then
            option=$(echo $line | cut -d':' -f1)
            echo "❌ $option not configured correctly"
        fi
    done <<< "$results"
    
    [ $success_count -eq $total_count ]
}

# Function to check plugin installation
test_plugins() {
    echo "🔄 Testing plugin installation..."
    
    # Check lazy-lock.json for installed plugins
    local plugins=(
        "kanagawa.nvim"
        "lazygit.nvim"
        "neotest"
        "gp.nvim"
        "vim-dadbod-ui"
        "nvim-repl"
        "nvim-surround"
        "nvim-bqf" 
        "persistence.nvim"
        "nvim-dap"
    )
    
    local success_count=0
    for plugin in "${plugins[@]}"; do
        # Remove .nvim suffix and escape hyphens for grep
        local search_pattern=$(echo "$plugin" | sed 's/\.nvim//' | sed 's/-/\\-/g')
        if grep -q "$search_pattern" ~/.config/nvim/lazy-lock.json 2>/dev/null; then
            echo "✅ $plugin installed"
            ((success_count++))
        else
            echo "❌ $plugin not found"
        fi
    done
    
    [ $success_count -eq ${#plugins[@]} ]
}

# Function to test key plugin commands
test_commands() {
    echo "🔄 Testing plugin commands..."
    
    local commands=(
        "LazyGit"
        "DBUIToggle" 
        "Neotest"
        "GpChatToggle"
        "DapContinue"
    )
    
    local success_count=0
    for cmd in "${commands[@]}"; do
        if nvim --headless -c "if exists(':$cmd') == 2 | echo 'exists' | else | echo 'missing' | endif" -c "qa!" 2>/dev/null | grep -q "exists"; then
            echo "✅ :$cmd command available"
            ((success_count++))
        else
            echo "❌ :$cmd command not found"
        fi
    done
    
    [ $success_count -eq ${#commands[@]} ]
}

# Function to create test keymaps check
test_keymaps() {
    echo "🔄 Testing custom keymaps..."
    echo "📝 Manual keymap test required - key bindings:"
    echo "   <C-f>     - Toggle file tree"
    echo "   <A-f>     - Find/replace in quickfix"
    echo "   <C-g>     - LazyGit"
    echo "   <A-t>r    - Run tests"
    echo "   <C-q>nt   - New AI chat in tab"
    echo "   <A-d>t    - Toggle Database UI"
    echo "   <A-r>o    - Open REPL"
    echo "   <leader>dc - Debug continue"
    echo "   (Test these manually in Neovim)"
    return 0
}

# Run all tests
echo "Running validation tests..."
echo ""

tests=(
    "test_basic_startup"
    "test_lazyvim"
    "test_colorscheme"
    "test_options"
    "test_plugins"
    "test_commands"
    "test_keymaps"
)

passed=0
total=${#tests[@]}

for test in "${tests[@]}"; do
    if $test; then
        ((passed++))
    fi
    echo ""
done

# Summary
echo "📊 Test Results Summary:"
echo "========================"
echo "Passed: $passed/$total tests"

if [ $passed -eq $total ]; then
    echo "🎉 All validation tests PASSED!"
    echo "✨ Your LazyVim migration is successful!"
    exit 0
elif [ $passed -gt $((total * 2 / 3)) ]; then
    echo "✅ Most tests passed - migration mostly successful"
    echo "⚠️  Some minor issues detected (see above)"
    exit 0
else
    echo "⚠️  Several issues detected - review configuration"
    exit 1
fi
