

# zsh

unameOut="$(uname -s)"
case "${unameOut}" in
	Linux*)	 machine="Linux" ;;
	Darwin*) machine="Mac" ;;
	CYGWIN*) machine="Cygwin" ;;
	MINGW*)  machine="MinGw" ;;
	*)       machine="UNKNOWN:${unameOut}"
esac

if [[ -z "$CHRISTOSH_HOME" ]]; then
    # TODO can we make it work without it?
    echo You need to define \$CHRISTOSH_HOME
else 
    . $CHRISTOSH_HOME/functions.sh

    #aliases
    if [[ "$machine" == "Mac" ]]; then
	    alias feen='osascript "$CHRISTOSH_HOME/applescript/toggle-caffiene.applescript"'
    fi
    alias gs='git status'
    alias gp='git pull'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias ls='ls -G'
    alias ll='ls -l'

    
    export PATH="$CHRISTOSH_HOME/bin:$PATH"
fi

if [[ "$machine" == "Mac" ]]; then
    # create aliases for vice apps
    if [[ -d /Applications/VICE ]]; then
        for i in /Applications/VICE/*.app; do
            alias ${i:18:-5}=open -a $i
        done
    fi
    
    # brew aliases
    
    alias brh='brew home'
    alias bri='brew info'
    alias brin='brew install'
    alias brl='brew list'
    alias bro='brew outdated'
    alias brs='brew search'
    alias bru='brew update'
fi
