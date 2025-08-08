# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/vito.pistelli/completions:"* ]]; then export FPATH="/Users/vito.pistelli/completions:$FPATH"; fi
# Path to your oh-my-zsh installation.
export ZSH=/Users/vito.pistelli/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gozilla"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast git-extras)

# User configuration

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vito.pistelli/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vito.pistelli/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vito.pistelli/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vito.pistelli/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

#fzf
source <(fzf --zsh)

# Enable Ctrl-x-e to edit command line with vim keybindings
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
  
# Created by `pipx` on 2025-01-30 15:52:45
export PATH=".:$PATH:/Users/vito.pistelli/.local/bin"

# bun completions
[ -s "/Users/vito.pistelli/.bun/_bun" ] && source "/Users/vito.pistelli/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
source $HOME/.tenv.completion.zsh


# Function to switch brances in Git repo's
#
# This allows me to switch to branches using ^x^x^b in any Git repository. It
# uses fzf to allow fuzzy searching through branch names. If a repository contains
# a package.json, it will detect differences between branches and run npm i.
# The numbers in this file correspond to the outline of what is happening,
# described in the blogpost at: https://medium.com/@jhkuperus/automatically-running-npm-install-when-switching-branches-432af36c9d2e
function select_branch() {
  local branch

  zle -M "Select a branch to switch to:\n"

  # 1. Here we list all available git branches and feed them to fzf
  # In fzf you can type and fuzzy-search for the branch you want
  # Once a branch is selected, it is returned and stored in branch
  branch=$(git branch -a --list --format "%(refname:lstrip=2)" | \
    FZF_DEFAULT_OPTS="--height 30% $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf)

  # Continue only if a branch was selected
  if [[ ! -z "$branch" ]];
  then
    local hasPackageJson=0
    local gitRoot=$(git rev-parse --show-toplevel)
    local currentPackageJsonHash=

    # 2. If package.json exists on the top of the repository...
    if [[ -f $gitRoot/package.json ]];
    then
      hasPackageJson=1
      # 3. Calculate the hash of relevant parts of package.json
      currentPackageJsonHash=$(cat $gitRoot/package.json | \
        jq ".dependencies,.devDependencies" | \
        md5)
    fi
    # Note to future self: the syntax ${variable/<regex>/<replacement>} is just frikkin awesome
    # 4. Actually switch to the selected branch
    git checkout ${branch/origin\//}

    if [[ $hasPackageJson == 1 ]];
    then
      # 5. Calculate has of package.json again
      local newPackageJsonHash=$(cat $gitRoot/package.json | jq ".dependencies,.devDependencies" | md5)

      # 6. If hashes differ, run npm install
      if [[ $newPackageJsonHash != $currentPackageJsonHash ]];
      then
        echo "The package.json has changed between branches," \
         " installing packages in 2 seconds unless you cancel it now..."
        sleep 2

        # 7. Make sure to remember the path if it's not $gitRoot
        local usePopd=0
        if [[ $(pwd) != $gitRoot ]];
        then
          pushd $gitRoot
          usePopd=1
        fi

        if [[ -f $gitRoot/bun.lock ]];
        then
          bun i
        elif [[ -f $gitRoot/yarn.lock ]];
        then
          yarn install
        else
          npm i
        fi

        # 7b. Use popd to restore the previous path
        if [[ $usePopd == 1 ]];
        then
          popd
        fi
      fi
    fi
  fi

  echo "\n\n"
  zle reset-prompt
}
 
zle -N select_branch

bindkey "^x^x^b" select_branch

export NODE_TLS_REJECT_UNAUTHORIZED=0
export EDITOR=nvim

# function aws_ecr_login() {

# }

# aws_account_id=$(aws sts get-caller-identity --query Account --output text)
# export aws_ecr_login=$(aws ecr get-login-password | docker login --username AWS --password-stdin  $(aws_account_id).dkr.ecr.us-east-1.amazonaws.com/v2)
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
 source /Users/vito.pistelli/.zshrc.secrets

source ~/.dotfiles/.zshrc.secrets