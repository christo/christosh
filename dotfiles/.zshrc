# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/christo/.oh-my-zsh"

if [[ "$OSTYPE" == darwin* ]]; then
	export BROWSER='open'
fi

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

bindkey -e

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	battery
	bgnotify
	brew
	cargo
	colored-man-pages
	command-not-found
	emoji
	fasd
	git
	# git-flow
	gradle
	httpie
	ipfs
	lein
	node
	npm
	osx
	pip
	pipenv
	rust
	rustup
	sbt
	scala
	thefuck
	themes
	tmux
	zsh-navigation-tools
	zsh_reload  	# use with command "src"

	# custom plugins checked out in ~/.oh-my-zsh/custom/plugins
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# Tab Completion of .ssh/known_hosts
local knownhosts
knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} ) 
zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(starship init zsh)"

# User configuration
export MAVEN_OPTS='-Xmx1024m -XX:PermSize=512m -server -XX:+UseParallelGC -Dmaven.artifact.threads=3'
export ATLAS_OPTS=$MAVEN_OPTS
export CATALINA_OPTS='-server -XX:+UseParallelGC'
#export M2_HOME=$HOME/lib/maven2
export GRIFFON_HOME=$HOME/lib/griffon
export VIM_DEVELOPMENT_HOME=$HOME/src/christo
#export LSCOLORS="ExfxcxdxBxegedabagacad" # made dirs and archives lighter (by using caps E and B) man ls for voodoo
export MAVEN_COLOR=true
export SCALA_HOME=$HOME/lib/scala
export KICK_HOME=$HOME/lib/kickassembler/v5.16


export RADIO_HOME="$HOME/src/christo/radio"
# TODO make zsh completion for radio
#. $RADIO_HOME/radio.bash_completion

export IPFS_PATH=$HOME/ipfs

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$JAVA_HOME/bin:$HOME/lib/groovy/bin:$HOME/lib/grails/bin:$PATH:$HOME/lib/atlassian-plugin-sdk/bin:/usr/local/share/npm/bin:$SCALA_HOME/bin:$RADIO_HOME
#
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR=vim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vim=nvim
alias vi=nvim

alias ka="java -jar $KICK_HOME/KickAss.jar"
alias chatty="java -jar /Applications/Chatty/Chatty.jar"

alias pbsort="pbpaste|sort|pbcopy"

fortune $HOME/src/christo/fortune

# TODO make all the functions we used in bash work:
export CHRISTOSH_HOME=$HOME/src/christo/christosh
source $CHRISTOSH_HOME/sourceme.sh

