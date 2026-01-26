#!/usr/bin/env bash

# Enhanced session-tokenizer: shows both existing tmux sessions AND project directories
# Configure your project directories here (non-existent ones are silently ignored)
PROJECT_DIRS=(
    ~/work/builds
    ~/projects
    ~/work
    ~/personal
    ~/personal/yt
    ~  # Home directory - catches all your project folders
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Get existing tmux sessions (if tmux is running)
    sessions=""
    if pgrep tmux &>/dev/null; then
        sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | sed 's/^/[session] /')
    fi

    # Get project directories (only from dirs that exist)
    directories=""
    for dir in "${PROJECT_DIRS[@]}"; do
        expanded_dir="${dir/#\~/$HOME}"
        if [[ -d "$expanded_dir" ]]; then
            found=$(find "$expanded_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
            if [[ -n "$found" ]]; then
                directories+="$found"$'\n'
            fi
        fi
    done

    # Remove trailing newline and duplicates
    directories=$(echo "$directories" | grep -v '^$' | sort -u)

    # Combine: sessions first, then directories
    if [[ -n $sessions ]]; then
        selected=$(printf "%s\n%s" "$sessions" "$directories" | fzf --prompt="session/dir> " --header="Sessions marked with [session]")
    else
        selected=$(echo "$directories" | fzf --prompt="dir> ")
    fi
fi

if [[ -z $selected ]]; then
    exit 0
fi

# Check if user selected an existing session
if [[ $selected == "[session] "* ]]; then
    session_name="${selected#\[session\] }"
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$session_name"
    else
        tmux switch-client -t "$session_name"
    fi
    exit 0
fi

# Otherwise, it's a directory - create or switch to session
selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# Function to create session with 3 windows
create_session_with_windows() {
    local session_name=$1
    local session_dir=$2

    # Create session with first window (claude)
    tmux new-session -ds "$session_name" -c "$session_dir" -n "claude"
    tmux send-keys -t "$session_name:claude" "claude" Enter

    # Create second window (nvim)
    tmux new-window -t "$session_name" -c "$session_dir" -n "nvim"
    tmux send-keys -t "$session_name:nvim" "nvim ." Enter

    # Create third window (shell)
    tmux new-window -t "$session_name" -c "$session_dir" -n "shell"

    # Select first window
    tmux select-window -t "$session_name:1"
}

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    # No tmux running - create and attach
    create_session_with_windows "$selected_name" "$selected"
    tmux attach-session -t "$selected_name"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    create_session_with_windows "$selected_name" "$selected"
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
