
if [[ -z "$CHRISTOSH_HOME" ]]; then
    echo You need to define \$CHRISTOSH_HOME
else 
    . $CHRISTOSH_HOME/functions.sh

    #aliases
    alias feen='osascript "$CHRISTOSH_HOME/applescript/toggle-caffiene.applescript"'
    alias gs='git status'
    alias gp='git pull'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias ls='ls -G'
    alias ll='ls -l'
    export LSCOLORS="ExfxcxdxBxegedabagacad" #made dirs and archives lighter by using caps E and B, man ls for voodoo
    export PATH="$CHRISTOSH_HOME/bin:$PATH"
fi


for i in /Applications/VICE/*.app; do
	alias ${i:18:-5}=open -a $i
done

