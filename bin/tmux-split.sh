#!/usr/bin/env zsh


split_top=$1; shift
split_bottom=$1; shift

created_new_session=false

if tmux display-message -p '#S' > /dev/null 2>&1; then
    sesh=$(tmux display-message -p '#S')
    echo "reusing current session: $sesh"
else
    sesh="happygas"
    echo "creating new session : $sesh"
    tmux -Au2 new-session -n "$sesh" -d
    created_new_session=true
fi

window_index=$(tmux new-window -t "$sesh" -P -F "#{window_index}")
tmux split-window -v

top_pane="$sesh:$window_index.1"
bottom_pane="$sesh:$window_index.2"

tmux send-keys -t "$top_pane" "$split_top" Enter
tmux send-keys -t "$bottom_pane" "$split_bottom" Enter

tmux select-layout even-vertical

# Only attach if we created a new session and we're not already in tmux
if [[ "$created_new_session" = true ]] && [[ -z "$TMUX" ]]; then
    echo attaching
    tmux -u2 attach -t "${sesh}"
fi
