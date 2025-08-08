# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/vito.pistelli/completions:"* ]]; then export FPATH="/Users/vito.pistelli/completions:$FPATH"; fi

# NVM setup with auto-switching for .nvmrc
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Auto-switch Node versions based on .nvmrc
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# AUTOCOMPLETION SETUP - This is the important part!
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Enable better completion matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select

# AWS completion
complete -C '/usr/local/bin/aws_completer' aws

# Terraform completion
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Tenv completion
source $HOME/.tenv.completion.zsh

# PATH exports
export PATH=".:$PATH:/Users/vito.pistelli/.local/bin"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/vito.pistelli/.bun/_bun" ] && source "/Users/vito.pistelli/.bun/_bun"

# Environment variables
export NODE_TLS_REJECT_UNAUTHORIZED=0
export EDITOR=nvim

# Initialize Starship prompt (install with: brew install starship)
eval "$(starship init zsh)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# Load secrets
[ -f ~/.dotfiles/.zshrc.secrets ] && source ~/.dotfiles/.zshrc.secrets
