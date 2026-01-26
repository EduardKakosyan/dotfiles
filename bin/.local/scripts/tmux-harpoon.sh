#!/usr/bin/env bash

# tmux-harpoon: Quick session switching like harpoon.nvim
# Usage:
#   tmux-harpoon mark [1-4]     - Mark current session to slot (auto-assigns if no slot given)
#   tmux-harpoon jump <1-4>     - Jump to session in slot
#   tmux-harpoon list           - List all marked sessions
#   tmux-harpoon menu           - Interactive fzf menu of marked sessions
#   tmux-harpoon clear [1-4]    - Clear slot (or all if no slot given)
#   tmux-harpoon swap <n> <m>   - Swap two slots

HARPOON_FILE="$HOME/.tmux-harpoon"
MAX_SLOTS=4

# Ensure harpoon file exists with empty slots
init_harpoon_file() {
    if [[ ! -f $HARPOON_FILE ]]; then
        for i in $(seq 1 $MAX_SLOTS); do
            echo ""
        done > "$HARPOON_FILE"
    fi
    # Ensure file has exactly MAX_SLOTS lines
    local lines=$(wc -l < "$HARPOON_FILE")
    if [[ $lines -lt $MAX_SLOTS ]]; then
        for i in $(seq $((lines + 1)) $MAX_SLOTS); do
            echo "" >> "$HARPOON_FILE"
        done
    fi
}

get_slot() {
    local slot=$1
    sed -n "${slot}p" "$HARPOON_FILE"
}

set_slot() {
    local slot=$1
    local value=$2
    # Use temp file for portability
    local tmp=$(mktemp)
    awk -v slot="$slot" -v val="$value" 'NR==slot {print val; next} {print}' "$HARPOON_FILE" > "$tmp"
    mv "$tmp" "$HARPOON_FILE"
}

get_current_session() {
    tmux display-message -p '#{session_name}' 2>/dev/null
}

find_empty_slot() {
    for i in $(seq 1 $MAX_SLOTS); do
        if [[ -z $(get_slot $i) ]]; then
            echo $i
            return
        fi
    done
    echo ""
}

find_session_slot() {
    local session=$1
    for i in $(seq 1 $MAX_SLOTS); do
        if [[ $(get_slot $i) == "$session" ]]; then
            echo $i
            return
        fi
    done
    echo ""
}

cmd_mark() {
    local slot=$1
    local current=$(get_current_session)

    if [[ -z $current ]]; then
        echo "Error: Not in a tmux session"
        exit 1
    fi

    # Check if session already marked
    local existing_slot=$(find_session_slot "$current")
    if [[ -n $existing_slot ]]; then
        echo "Session '$current' already in slot $existing_slot"
        return
    fi

    if [[ -z $slot ]]; then
        slot=$(find_empty_slot)
        if [[ -z $slot ]]; then
            echo "All slots full. Clear a slot first or specify slot number to overwrite."
            cmd_list
            exit 1
        fi
    fi

    if [[ $slot -lt 1 || $slot -gt $MAX_SLOTS ]]; then
        echo "Invalid slot: $slot (must be 1-$MAX_SLOTS)"
        exit 1
    fi

    set_slot "$slot" "$current"
    echo "Marked '$current' → slot $slot"
}

cmd_jump() {
    local slot=$1

    if [[ -z $slot ]]; then
        echo "Usage: tmux-harpoon jump <1-$MAX_SLOTS>"
        exit 1
    fi

    if [[ $slot -lt 1 || $slot -gt $MAX_SLOTS ]]; then
        echo "Invalid slot: $slot (must be 1-$MAX_SLOTS)"
        exit 1
    fi

    local session=$(get_slot "$slot")

    if [[ -z $session ]]; then
        echo "Slot $slot is empty"
        exit 1
    fi

    if ! tmux has-session -t="$session" 2>/dev/null; then
        echo "Session '$session' no longer exists"
        exit 1
    fi

    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$session"
    else
        tmux switch-client -t "$session"
    fi
}

cmd_list() {
    echo "tmux-harpoon slots:"
    echo "─────────────────────"
    for i in $(seq 1 $MAX_SLOTS); do
        local session=$(get_slot $i)
        if [[ -n $session ]]; then
            # Check if session still exists
            if tmux has-session -t="$session" 2>/dev/null; then
                echo "  $i: $session"
            else
                echo "  $i: $session (dead)"
            fi
        else
            echo "  $i: (empty)"
        fi
    done
}

cmd_menu() {
    local items=""
    for i in $(seq 1 $MAX_SLOTS); do
        local session=$(get_slot $i)
        if [[ -n $session ]] && tmux has-session -t="$session" 2>/dev/null; then
            items+="$i: $session"$'\n'
        fi
    done

    if [[ -z $items ]]; then
        echo "No sessions marked"
        exit 1
    fi

    local selected=$(echo -n "$items" | fzf --prompt="harpoon> " --header="Jump to marked session")

    if [[ -n $selected ]]; then
        local slot="${selected%%:*}"
        cmd_jump "$slot"
    fi
}

cmd_clear() {
    local slot=$1

    if [[ -z $slot ]]; then
        # Clear all
        for i in $(seq 1 $MAX_SLOTS); do
            set_slot "$i" ""
        done
        echo "Cleared all slots"
    else
        if [[ $slot -lt 1 || $slot -gt $MAX_SLOTS ]]; then
            echo "Invalid slot: $slot (must be 1-$MAX_SLOTS)"
            exit 1
        fi
        set_slot "$slot" ""
        echo "Cleared slot $slot"
    fi
}

cmd_swap() {
    local slot1=$1
    local slot2=$2

    if [[ -z $slot1 || -z $slot2 ]]; then
        echo "Usage: tmux-harpoon swap <slot1> <slot2>"
        exit 1
    fi

    local val1=$(get_slot "$slot1")
    local val2=$(get_slot "$slot2")
    set_slot "$slot1" "$val2"
    set_slot "$slot2" "$val1"
    echo "Swapped slots $slot1 ↔ $slot2"
}

# Main
init_harpoon_file

case "${1:-}" in
    mark)  cmd_mark "$2" ;;
    jump)  cmd_jump "$2" ;;
    list)  cmd_list ;;
    menu)  cmd_menu ;;
    clear) cmd_clear "$2" ;;
    swap)  cmd_swap "$2" "$3" ;;
    *)
        echo "tmux-harpoon - Quick session switching"
        echo ""
        echo "Commands:"
        echo "  mark [1-4]     Mark current session to slot"
        echo "  jump <1-4>     Jump to session in slot"
        echo "  list           List all marked sessions"
        echo "  menu           Interactive fzf menu"
        echo "  clear [1-4]    Clear slot (or all)"
        echo "  swap <n> <m>   Swap two slots"
        ;;
esac
