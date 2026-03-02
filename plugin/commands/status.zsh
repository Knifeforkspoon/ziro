#!/usr/bin/env zsh
# ziro status - Show current progress

ziro_status() {
    local feature_name=$1
    local ziro_dir=".ziro"
    local specs_dir="$ziro_dir/specs"

    # Validate ziro is initialized
    if [[ ! -d "$ziro_dir" ]]; then
        echo "❌ Ziro not initialized. Run: ziro init"
        return 1
    fi

    if [[ -z "$feature_name" ]]; then
        echo "❌ Feature name required: ziro status [feature-name]"
        return 1
    fi

    local feature_dir="$specs_dir/$feature_name"

    if [[ ! -d "$feature_dir" ]]; then
        echo "❌ Feature '$feature_name' not found"
        return 1
    fi

    echo "📊 Progress: $feature_name"
    echo ""

    if [[ -f "$feature_dir/tasks.md" ]]; then
        echo "=== TASK PROGRESS ==="
        # Count completed vs total tasks
        local total=$(grep -c "^- \[" "$feature_dir/tasks.md" || echo 0)
        local completed=$(grep -c "^- \[x\]" "$feature_dir/tasks.md" || echo 0)
        echo "Tasks: $completed / $total complete"
        echo ""

        # Show next incomplete task
        echo "Next task to implement:"
        grep -A 2 "^- \[ \]" "$feature_dir/tasks.md" | head -3
    fi
}
