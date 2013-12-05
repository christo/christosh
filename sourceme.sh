if [[ -z "$CHRISTOSH_HOME" ]]; then
    echo You need to define \$CHRISTOSH_HOME
else 
    . $CHRISTOSH_HOME/functions.sh

    #aliases
    alias gs='git status'
fi
