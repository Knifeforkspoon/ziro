#!/usr/bin/env zsh
# ziro go - Resume The Wiggum Loop from last incomplete task

source "${0:h}/ralph.zsh"

ziro_go() {
    local feature_name=$1
    local ziro_dir=".ziro"
    local specs_dir="$ziro_dir/specs"

    # Validate ziro is initialized
    if [[ ! -d "$ziro_dir" ]]; then
        echo "❌ Ziro not initialized. Run: ziro init"
        return 1
    fi

    if [[ -z "$feature_name" ]]; then
        echo "❌ Feature name required: ziro go [feature-name]"
        return 1
    fi

    local feature_dir="$specs_dir/$feature_name"

    if [[ ! -d "$feature_dir" ]]; then
        echo "❌ Feature '$feature_name' not found"
        return 1
    fi

    echo "▶️  Resuming The Wiggum Loop: $feature_name"
    echo "   Spec directory: $feature_dir"
    echo ""

    # Check required files exist
    for file in requirements.md design.md tasks.md; do
        if [[ ! -f "$feature_dir/$file" ]]; then
            echo "❌ Missing $file - feature spec incomplete"
            return 1
        fi
    done

    # Start implementation loop (will detect where we are)
    _ziro_ralph_loop "$feature_name" "$feature_dir"
}
