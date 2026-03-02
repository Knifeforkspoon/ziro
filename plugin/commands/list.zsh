#!/usr/bin/env zsh
# ziro ls - List all feature specs with status

ziro_list() {
    local ziro_dir=".ziro"
    local specs_dir="$ziro_dir/specs"

    # Validate ziro is initialized
    if [[ ! -d "$ziro_dir" ]]; then
        echo "❌ Ziro not initialized. Run: ziro init"
        return 1
    fi

    if [[ ! -d "$specs_dir" ]]; then
        echo "📭 No specs directory found"
        return 0
    fi

    # Check if any features exist
    if ! ls -1 "$specs_dir" 2>/dev/null | grep -v "^\.gitkeep$" | grep -q .; then
        echo "📭 No features found"
        echo ""
        echo "Create one: ziro req create [name]"
        return 0
    fi

    echo "📋 Ziro Features"
    echo ""

    # List all features with status
    for feature_dir in "$specs_dir"/*/; do
        local feature_name=$(basename "$feature_dir")

        local req_status="❌"
        local des_status="❌"
        local tsk_status="❌"

        # Check requirements
        if [[ -f "$feature_dir/requirements.md" ]]; then
            if grep -q "Approved" "$feature_dir/requirements.md" 2>/dev/null; then
                req_status="✓"
            else
                req_status="◐"
            fi
        fi

        # Check design
        if [[ -f "$feature_dir/design.md" ]]; then
            if grep -q "Approved" "$feature_dir/design.md" 2>/dev/null; then
                des_status="✓"
            else
                des_status="◐"
            fi
        fi

        # Check tasks
        if [[ -f "$feature_dir/tasks.md" ]]; then
            if grep -q "Approved" "$feature_dir/tasks.md" 2>/dev/null; then
                tsk_status="✓"
            else
                tsk_status="◐"
            fi
        fi

        # Check implementation progress
        local total_tasks=0
        local completed_tasks=0

        if [[ -f "$feature_dir/tasks.md" ]]; then
            total_tasks=$(grep -c "^- \[" "$feature_dir/tasks.md" 2>/dev/null || echo 0)
            completed_tasks=$(grep -c "^- \[x\]" "$feature_dir/tasks.md" 2>/dev/null || echo 0)
        fi

        # Format output
        printf "  • %-25s [R:%s D:%s T:%s] %2d/%2d\n" \
            "$feature_name" \
            "$req_status" \
            "$des_status" \
            "$tsk_status" \
            "$completed_tasks" \
            "$total_tasks"
    done

    echo ""
    echo "Legend: R=Requirements D=Design T=Tasks"
    echo "        ✓=Approved  ◐=Draft  ❌=Not Started"
    echo ""
    echo "Commands:"
    echo "  ziro req create [name]      - Gather requirements"
    echo "  ziro plan create [name]     - Create design"
    echo "  ziro ralph start [name]     - Start implementation"
}
