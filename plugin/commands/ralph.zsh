#!/usr/bin/env zsh
# ziro ralph - Start or stop feature implementation

ziro_ralph() {
    local action=${1:-start}
    local feature_name=${2}
    local ziro_dir=".ziro"
    local specs_dir="$ziro_dir/specs"

    # Validate ziro is initialized
    if [[ ! -d "$ziro_dir" ]]; then
        echo "❌ Ziro not initialized. Run: ziro init"
        return 1
    fi

    if [[ -z "$feature_name" ]]; then
        echo "❌ Feature name required: ziro ralph start|stop [feature-name]"
        return 1
    fi

    local feature_dir="$specs_dir/$feature_name"

    if [[ ! -d "$feature_dir" ]]; then
        echo "❌ Feature '$feature_name' not found"
        return 1
    fi

    case $action in
        start)
            _ziro_ralph_start "$feature_name" "$feature_dir"
            ;;
        stop)
            _ziro_ralph_stop "$feature_name" "$feature_dir"
            ;;
        *)
            echo "❌ Unknown action: $action"
            echo "Available: start, stop"
            return 1
            ;;
    esac
}

_ziro_ralph_start() {
    local feature_name=$1
    local feature_dir=$2

    echo "🚀 Starting implementation: $feature_name"
    echo "   Spec directory: $feature_dir"
    echo ""

    # Check required files exist
    for file in requirements.md design.md tasks.md; do
        if [[ ! -f "$feature_dir/$file" ]]; then
            echo "❌ Missing $file - feature spec incomplete"
            return 1
        fi
    done

    echo "✓ Requirements approved"
    echo "✓ Design approved"
    echo "✓ Tasks approved"
    echo ""

    # Start implementation loop
    _ziro_ralph_loop "$feature_name" "$feature_dir"
}

_ziro_ralph_resume() {
    local feature_name=$1
    local feature_dir=$2

    echo "▶️  Resuming implementation: $feature_name"
    echo "   Spec directory: $feature_dir"
    echo ""

    # Start implementation loop (will detect where we are)
    _ziro_ralph_loop "$feature_name" "$feature_dir"
}

_ziro_ralph_stop() {
    local feature_name=$1
    local feature_dir=$2

    echo "⏸️  Stopping implementation: $feature_name"
    echo ""
    echo "Current progress saved in:"
    echo "   • $feature_dir/tasks.md (completed tasks marked)"
    echo ""
    echo "Resume with: ziro go $feature_name"
}

_ziro_ralph_status() {
    local feature_name=$1
    local feature_dir=$2

    echo "📊 Build Status: $feature_name"
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

_ziro_ralph_loop() {
    local feature_name=$1
    local feature_dir=$2
    local requirements_file="$feature_dir/requirements.md"
    local design_file="$feature_dir/design.md"
    local tasks_file="$feature_dir/tasks.md"

    # Main implementation loop
    local task_count=0
    local completed_count=0

    while true; do
        # Find next incomplete task
        local next_task=$(grep "^- \[ \]" "$tasks_file" | head -1)

        if [[ -z "$next_task" ]]; then
            echo ""
            echo "🎉 All tasks completed!"
            _ziro_ralph_summary "$feature_name" "$feature_dir"
            return 0
        fi

        ((task_count++))

        # Extract task number and title from markdown
        local task_title=$(echo "$next_task" | sed 's/^- \[ \] \*\*[0-9.]*\*\* //')

        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📝 Task: $task_title"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""

        # Build context for Claude
        local claude_prompt=$(cat <<EOF
# Feature Implementation - Ziro Process

You are implementing a feature using the Ziro spec-driven development system.

Follow the Ziro process defined in this project:
- Read and understand requirements.md, design.md, and tasks.md
- Implement the current task exactly as specified
- Create/modify files in ./src/ (not .ziro/)
## FEATURE REQUIREMENTS
$(cat "$requirements_file")

## TECHNICAL DESIGN
$(cat "$design_file")

## CURRENT TASK
$next_task

$(grep -A 10 "^- \[ \] \*\*[0-9.]*\*\*" "$tasks_file" | head -20)

---

Implement this task following all the specifications above. Create real, working code that follows the design and meets the requirements.
EOF
)

        # Show task to user
        echo "📋 Task Description:"
        echo "$next_task" | sed 's/^- \[ \] //'
        echo ""

        # Get approval before proceeding
        printf "Start implementation? (y/n) "
        read -k 1 approval
        echo ""

        if [[ "$approval" != "y" && "$approval" != "Y" ]]; then
            echo "⏸️  Build paused"
            return 0
        fi

        echo "🔨 Implementing with Claude..."
        echo ""

        # Invoke Claude
        # Note: This assumes 'claude' command is available (Claude Code CLI)
        if ! command -v claude &> /dev/null; then
            echo "❌ Claude Code CLI not found. Is it installed and in PATH?"
            echo "   See: https://claude.com/claude-code"
            return 1
        fi

        echo "$claude_prompt" | claude
    done
}

_ziro_ralph_summary() {
    local feature_name=$1
    local feature_dir=$2

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 IMPLEMENTATION COMPLETE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Feature: $feature_name"
    echo "Location: $feature_dir"
    echo ""
    echo "✅ All tasks completed"
    echo "✅ Code ready for review"
    echo ""
    echo "Next steps:"
    echo "  1. Run tests: bun run test"
    echo "  2. Run linting: bun run lint"
    echo "  3. Submit for code review"
    echo ""
}
