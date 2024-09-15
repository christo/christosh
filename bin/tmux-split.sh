#!/usr/bin/env zsh

# using tmux session named cw
# start clonewatch with its logs tailing in two panes of a new tmux window
# if such a session exists, attach to it, otherwise create it

set -eu

split_top=$1; shift
split_bottom=$1; shift

# create new session 
# -u means utf8 -2 means 256 colour
# -t foo:bar sets target session "foo" new window "bar"
# -d start detached (will attach at end)
if tmux display-message -p '#S' > /dev/null 2>&1; then
    current_session=$(tmux display-message -p '#S')
    echo "reusing current session: $current_session"
else
    current_session="happygas"
    echo "creating new session : $current_session"
    tmux -Au2 new-session -n "$current_session" -d
fi
tmux select-window -t "${current_session}:split_top"
tmux send-keys -t "${current_session}:split_top" "split_top" Enter
# vertical split (top and bottom panes), new pane receives focus
tmux split-window -v
tmux send-keys -t "${current_session}:split_bottom" "$split_bottom" Enter
tmux select-layout even-vertical
# now attach to it
tmux -u2 attach -t "${current_session}"
