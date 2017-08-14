# Path to your oh-my-zsh installation.
export ZSH=/Users/vpistelli/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gozilla"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gitfast git-extras)

# User configuration

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export INTELJS_CLIENT_ID=
export INTELJS_SIGNATURE=

export INTELJS_CLIENT_ID_TEST=
export INTELJS_SIGNATURE_TEST=

#export DATADOG_API_KEY=
#export DATADOG_APPLICATION_KEY=

alias bers='bundle exec rails s'
alias ber='bundle exec rspec'
alias work='cd /Users/vpistelli/dev/careerbuilder'
alias lsl='ls -la'
alias vim='mvim -v'
alias :q='exit'
alias token='NODE_ENV=production node /Users/vpistelli/dev/careerbuilder/tokenizer/index.js'
alias test_token='NODE_ENV=staging node /Users/vpistelli/dev/careerbuilder/tokenizer/index_wwwtest.js'
alias googleToken='node /Users/vpistelli/dev/careerbuilder/node/google-credentials/get-credentials.js | pbcopy'

alias kula='cp ~/.aws/credentials_kula ~/.aws/credentials'
alias cb='cp ~/.aws/credentials_cb ~/.aws/credentials'
alias mobile_app='cp ~/.aws/credentials_mobile_app ~/.aws/credentials'

#######
# nvm #
#######
export NVM_DIR="/Users/vpistelli/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm use 4.3.2

#export PATH=$PATH:/usr/local/bin

# added by travis gem
[ -f /Users/vpistelli/.travis/travis.sh ] && source /Users/vpistelli/.travis/travis.sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval $(/usr/libexec/path_helper -s)

source ~/.iterm2_shell_integration.`basename $SHELL`

#########
# rbenv #
#########
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"
