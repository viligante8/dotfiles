# ============================================================================
# OS DETECTION
# ============================================================================
# Detect operating system for cross-platform compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    # macOS-specific paths
    HOMEBREW_PREFIX="/opt/homebrew"  # Apple Silicon default
    if [[ ! -d "$HOMEBREW_PREFIX" ]]; then
        HOMEBREW_PREFIX="/usr/local"  # Intel Mac fallback
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    # Linux: use system package managers (apt/yum/pacman/etc.)
    HOMEBREW_PREFIX=""  # Not used on Linux
else
    OS="unknown"
    HOMEBREW_PREFIX=""
fi

# ============================================================================
# OPTIMIZED ZSHRC - Fast Startup with Smart Auto-Switching
# ============================================================================
# This configuration prioritizes fast shell startup (~0.2s instead of 1.6s)
# while maintaining automatic Node version switching in project directories.
#
# Key optimizations:
# - Lazy-load NVM (only when needed)
# - Lazy-load completions (only when commands are used)
# - Smart project detection for auto-switching
# - Cached completion dumps for faster loading
# ============================================================================

# ============================================================================
# AI INTEGRATION (Pre-block)
# ============================================================================
# AI shell integration - must be at the top
# ============================================================================
# DOTFILES DIRECTORY SETUP
# ============================================================================
# Define dotfiles directory early so it can be used in PATH exports
# Handle both symlinked and direct .zshrc files (cross-platform)
if [[ -L ~/.zshrc ]]; then
    # Symlinked: resolve the symlink
    # Use readlink (works on both macOS and Linux, though behavior differs)
    LINK_TARGET=$(readlink ~/.zshrc 2>/dev/null)
    if [[ -n "$LINK_TARGET" ]]; then
        # If link target is relative, resolve it relative to ~
        if [[ "$LINK_TARGET" != /* ]]; then
            LINK_TARGET="${HOME}/${LINK_TARGET}"
        fi
        DOTFILES_DIR="$(cd "$(dirname "$LINK_TARGET")" && pwd)"
    else
        # Fallback: try to get absolute path of symlink target
        DOTFILES_DIR="$(cd "$(dirname "$(readlink ~/.zshrc)")" && pwd 2>/dev/null || echo "${HOME}/.dotfiles")"
    fi
elif [[ -f ~/.zshrc ]]; then
    # Direct file: use the file's directory
    DOTFILES_DIR="$(cd "$(dirname ~/.zshrc)" && pwd)"
else
    # Fallback: assume standard location
    DOTFILES_DIR="${HOME}/.dotfiles"
fi

# ============================================================================
# COMPLETION SYSTEM SETUP
# ============================================================================
# Add custom completion paths (lightweight) - use $HOME instead of hardcoded path
CUSTOM_COMPLETIONS_DIR="${HOME}/completions"
if [[ -d "$CUSTOM_COMPLETIONS_DIR" ]] && [[ ":$FPATH:" != *":${CUSTOM_COMPLETIONS_DIR}:"* ]]; then 
    export FPATH="${CUSTOM_COMPLETIONS_DIR}:$FPATH"
fi

# ============================================================================
# SMART NVM SETUP - Fast Startup with Auto-Switching
# ============================================================================
export NVM_DIR="$HOME/.nvm"

# Set up default Node path without loading NVM (fast startup)
# This gives you a working Node immediately without the 1.6s NVM load time
if [[ -f "$NVM_DIR/alias/default" ]]; then
  DEFAULT_NODE_VERSION=$(cat "$NVM_DIR/alias/default")
  export PATH="$NVM_DIR/versions/node/$DEFAULT_NODE_VERSION/bin:$PATH"
fi

# Check if we're in a Node.js project directory
is_node_project() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    # Look for common Node.js project indicators
    if [[ -f "$dir/.nvmrc" ]] || [[ -f "$dir/package.json" ]] || [[ -f "$dir/yarn.lock" ]] || [[ -f "$dir/pnpm-lock.yaml" ]] || [[ -f "$dir/bun.lock" ]] || [[ -f "$dir/bun.lockb" ]]; then
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

# Load NVM only when needed (smart loading)
load_nvm_if_needed() {
  # Skip if NVM is already loaded
  if command -v nvm &> /dev/null; then
    return 0
  fi
  
  # Only load NVM if we're in a Node project
  if is_node_project; then
    echo "🚀 Loading NVM (Node project detected)..."
    
    # Load NVM from standard installation location
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
      \. "$NVM_DIR/nvm.sh"
    elif [[ "$OS" == "macos" ]] && [[ -n "$HOMEBREW_PREFIX" ]] && [[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]]; then
      # macOS Homebrew installation (fallback)
      \. "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
      [[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ]] && \. "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"
    fi
    
    # Now do the auto-switching
    load_nvmrc_version
    return 0
  fi
  return 1
}

# Auto-switch Node versions based on .nvmrc (your existing logic)
load_nvmrc_version() {
  # Only run if NVM is loaded
  if ! command -v nvm &> /dev/null; then
    return 1
  fi
  
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      echo "📦 Installing Node version from .nvmrc..."
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      echo "🔄 Switching to Node $(cat "${nvmrc_path}")..."
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "↩️  Reverting to default Node version..."
    nvm use default
  fi
}

# Hook to check for NVM loading on directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd load_nvm_if_needed

# Check on shell startup (for tmux sessions that start in project directories)
load_nvm_if_needed

# ============================================================================
# LAZY-LOADED NODE COMMANDS
# ============================================================================
# These commands will trigger NVM loading only when you actually use them
# This keeps startup fast while ensuring the right Node version is used

# Lazy load NVM command itself
nvm() {
  unset -f nvm
  
  # Load NVM from standard installation location
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    \. "$NVM_DIR/nvm.sh"
  elif [[ "$OS" == "macos" ]] && [[ -n "$HOMEBREW_PREFIX" ]] && [[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]]; then
    # macOS Homebrew installation (fallback)
    \. "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
    [[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ]] && \. "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"
  fi
  
  nvm "$@"
}

# Lazy load Node.js
node() {
  unset -f node
  load_nvm_if_needed
  command node "$@"
}

# Lazy load npm
npm() {
  unset -f npm  
  load_nvm_if_needed
  command npm "$@"
}

# Lazy load npx
npx() {
  unset -f npx
  load_nvm_if_needed
  command npx "$@"
}

# Lazy load yarn
yarn() {
  unset -f yarn
  load_nvm_if_needed
  command yarn "$@"
}

# Lazy load bun
bun() {
  unset -f bun
  load_nvm_if_needed
  command bun "$@"
}

# Lazy load bunx
bunx() {
  unset -f bunx
  load_nvm_if_needed
  command bunx "$@"
}

# ============================================================================
# FZF INTEGRATION
# ============================================================================
# Fuzzy finder for files and command history - lightweight and fast
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================================================
# SHELL EDITING MODE
# ============================================================================
# Force emacs-style line editing (normal terminal behavior)
# This prevents zsh from switching to vi mode based on EDITOR variable
bindkey -e

# ============================================================================
# ENHANCED HISTORY SEARCH
# ============================================================================
# Type a command, then use up/down arrows to filter through history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow
bindkey "^[OA" up-line-or-beginning-search    # Up arrow (alternative)
bindkey "^[OB" down-line-or-beginning-search  # Down arrow (alternative)

# ============================================================================
# OPTIMIZED COMPLETION SYSTEM
# ============================================================================
# Git aliases for AI commit messages
# ============================================================================
alias gcm='commit-msg'
alias gcma='commit-msg --amend'

# ============================================================================
# Load completion system with caching for faster startup
autoload bashcompinit && bashcompinit
autoload -Uz compinit

# Use cached completions if dump is less than 24 hours old (much faster)
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit                # Full initialization (slower, but thorough)
else
  compinit -C             # Skip security check (faster startup)
fi

# Better completion matching and display
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # Case insensitive
zstyle ':completion:*' list-colors ''                    # Colored completions
zstyle ':completion:*' menu select                       # Interactive menu

dbdev() {
  command pgcli $DATABASE_URI
}
dbprod() {
  command pgcli $DB_URL_PROD
}

# ============================================================================
# LAZY-LOADED TOOL COMPLETIONS
# ============================================================================
# These completions are only loaded when you actually use the commands
# This prevents slow startup from loading all completions upfront

# AWS CLI completion (lazy-loaded)
aws() {
  unset -f aws
  # Load AWS completion only when first used
  if command -v aws_completer &> /dev/null; then
    complete -C 'aws_completer' aws
  fi
  command aws "$@"
}

# Terraform completion (lazy-loaded)
terraform() {
  unset -f terraform
  # Load Terraform completion only when first used
  if command -v terraform &> /dev/null; then
    complete -o nospace -C terraform terraform
  fi
  command terraform "$@"
}

# Tenv completion (lightweight, keep loaded since you use it frequently)
[ -f "$HOME/.tenv.completion.zsh" ] && source "$HOME/.tenv.completion.zsh"

# ============================================================================
# PATH AND ENVIRONMENT SETUP
# ============================================================================
# Essential path exports and environment variables

# Add current directory and local bin to PATH
export PATH=".:$PATH:${HOME}/.local/bin"

# Add dotfiles bin directory to PATH
export PATH="$DOTFILES_DIR/bin:$PATH"

# Bun setup (JavaScript runtime - lightweight)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[[ -s "${HOME}/.bun/_bun" ]] && source "${HOME}/.bun/_bun"

# Development environment variables
# export NODE_TLS_REJECT_UNAUTHORIZED=0  # For development with self-signed certs
export EDITOR=nvim                      # Default editor for git, etc.

# Quick access to keymaps cheat sheet
alias keymaps="nvim $DOTFILES_DIR/KEYMAPS.md"
alias cheat="cat $DOTFILES_DIR/KEYMAPS.md | head -50"  # Quick preview

# ============================================================================
# STARSHIP PROMPT
# ============================================================================
# Beautiful, fast prompt - this is actually quite fast, so keep it loaded
eval "$(starship init zsh)"

# Fix Ctrl-C interrupt issues by disabling right prompt
RPROMPT=""

# ============================================================================
# SECRETS AND WORKFLOW INTEGRATION
# ============================================================================
# Load private environment variables (API keys, tokens, etc.)
[ -f "$DOTFILES_DIR/zshrc.secrets" ] && source "$DOTFILES_DIR/zshrc.secrets"

# Load tmux workflow functions (your custom session management)
[ -f "$DOTFILES_DIR/tmux-workflows.sh" ] && source "$DOTFILES_DIR/tmux-workflows.sh"

# ============================================================================
# AI INTEGRATION (Post-block)
# ============================================================================
# AI shell integration - must be at the bottom
# ============================================================================
# PERFORMANCE NOTES
# ============================================================================
# Expected startup time: ~0.2-0.4 seconds (down from 1.6 seconds)
# 
# What's fast:
# - Starship prompt initialization
# - Basic PATH setup
# - Tenv completion (small file)
# - AI CLI integration
#
# What's lazy-loaded (only when needed):
# - NVM and Node.js ecosystem
# - AWS CLI completions  
# - Terraform completions
# - Heavy completion systems
#
# Auto-switching behavior:
# - Happens automatically when entering project directories
# - Triggered by .nvmrc, package.json, yarn.lock, or pnpm-lock.yaml
# - Falls back to manual loading when using node/npm/yarn commands
# ============================================================================

# opencode (if installed)
if [[ -d "${HOME}/.opencode/bin" ]]; then
    export PATH="${HOME}/.opencode/bin:$PATH"
fi

# Colima Docker configuration for testcontainers (macOS/Linux with Colima)
if [[ -d "${HOME}/.colima/default" ]]; then
    export DOCKER_HOST=unix://${HOME}/.colima/default/docker.sock
    export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
fi
export NODE_OPTIONS=--dns-result-order=ipv4first
