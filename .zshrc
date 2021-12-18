# Set config home if not already set
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"

# Path to your oh-my-zsh installation.
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
ZSH_THEME="common"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%Y/%m/%d %H:%M:%S"

# Plugin config
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
export _Z_DATA="$XDG_CACHE_HOME/.z"

# Load plugins
# Example format: plugins=(rails git textmate ruby lighthouse)
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
plugins=(z zsh-autosuggestions zsh-syntax-highlighting)

if [ -f $ZSH/oh-my-zsh.sh ];
then
  source $ZSH/oh-my-zsh.sh
else
  echo 'wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
fi

## User Config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export LANG=en_US.UTF-8

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
export EDITOR='nvim'
export HISTORY_IGNORE="fg"
export MANPAGER="vim -M +MANPAGER -"  # Uses vim to read manpages

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
fi

export FZF_DEFAULT_OPTS="--height=25 --multi --no-mouse --cycle"
# export LS_COLORS='ow=01;36;40'

# Generic aliases
alias l='ls -Alh'
alias la='ls -Alh'
alias ll='ls -lh'
alias gst='git status'
alias vi=$EDITOR
alias vim=$EDITOR
alias gpo='git push origin $(git branch --show-current)'
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# specific aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Start in home dir in WSL
[ -n "$WSL_DISTRO_NAME" ] && cd $HOME
