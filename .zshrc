[ -z ${PLATFORM+x} ] && export PLATFORM=$(uname -s)

export LANG=en_US.UTF-8

# Set config home if not already set
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"

# We'll want to set these explicitly, because if oh-my-zsh doesn't run,
# our history file will truncate to the default value of SAVEHIST (1000)
export HISTFILE="$XDG_DATA_HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000
# see more history options here https://zsh.sourceforge.io/Doc/Release/Options.html

# Include local bin
export PATH="$PATH:$HOME/.local/bin"

# Path to oh-my-zsh installation
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
ZSH_THEME="common"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%Y/%m/%d %H:%M:%S"


# Load plugins
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
export _Z_DATA="$XDG_CACHE_HOME/.z"
plugins=(fzf-tab z zsh-autosuggestions zsh-syntax-highlighting)

if [ -f "$ZSH/oh-my-zsh.sh" ];
then
  source "$ZSH/oh-my-zsh.sh"

  ZSH_HIGHLIGHT_STYLES[comment]=fg=245  # make comments show up on black bg

  # Enable multi select in tab completions using tab and shift tab
  # zstyle ':fzf-tab:complete:*' fzf-bindings 'tab:toggle+down,shift-tab:toggle+up'
else
  echo "ohmyzsh not found, try: wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  return  # don't run the rest of the file
fi

### User Config ###
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

setopt globdots
export EDITOR='nvim'
export MANPAGER='nvim +Man!'  # Use neovim to read manpages

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
elif command -v rg > /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
fi

export FZF_DEFAULT_OPTS="--height=25 --multi --no-mouse --cycle"
export FZF_COMPLETION_TRIGGER=',,'
# export LS_COLORS='ow=01;36;40'

if [ "$PLATFORM" = 'Darwin' ]; then
  # Add .NET Core SDK tools
  export PATH="$PATH:$HOME/.dotnet/tools"

  # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
  export PATH="$PATH:$HOME/.rvm/bin"
  eval "$(direnv hook zsh)"
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

  ## oh-my-zsh already autoloads these
  # autoload -U +X bashcompinit && bashcompinit
  # autoload -Uz compinit && compinit

  # vault autocompletion
  complete -o nospace -C /usr/local/bin/vault vault

  # AWS autocompletion and auto prompting
  complete -C '/usr/local/bin/aws_completer' aws
  export AWS_CLI_AUTO_PROMPT=on-partial
  export AWS_DEFAULT_OUTPUT=table  # use '--output text' in scripts
fi

# Generic aliases
alias l='ls -Alh'
alias la='ls -Alh'
alias ll='ls -lh'
alias vi="$EDITOR"
alias vim="$EDITOR"
alias gst='git status'
alias gpo='git push origin $(git branch --show-current)'
# alias -g dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git() {
    if [ "$PWD" = "$HOME" ]; then
        command git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
    else
        command git "$@"
    fi
}

# Start in home dir in WSL
if [ -n "$WSL_DISTRO_NAME" ]; then
    export LS_COLORS='ow=01;36;40'
    cd "$HOME"
fi

# custom stuff
if [ -f "$XDG_DATA_HOME/utils/.bash_aliases" ]; then
  . "$XDG_DATA_HOME/utils/.bash_aliases"
fi
