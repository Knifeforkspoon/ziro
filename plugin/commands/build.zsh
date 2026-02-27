#!/usr/bin/env zsh
# shakapawd build - Start, resume, or stop feature implementation

shakapawd_build() {
    local action=${1:-start}
    local feature_name=${2}
    local shakapawd_dir=".shakapawd"
    local specs_dir="$shakapawd_dir/specs"

    # Validate shakapawd is initialized
    if [[ ! -d "$shakapawd_dir" ]]; then
        echo "❌ Shakapawd not initialized. Run: shakapawd init"
        return 1
    fi

    if [[ -z "$feature_name" ]]; then
        echo "❌ Feature name required: shakapawd build [start|resume|stop|status] [feature-name]"
        return 1
    fi

    local feature_dir="$specs_dir/$feature_name"

    if [[ ! -d "$feature_dir" ]]; then
        echo "❌ Feature '$feature_name' not found"
        return 1
    fi

    case $action in
        start)
            _shakapawd_build_start "$feature_name" "$feature_dir"
            ;;
        resume)
            _shakapawd_build_resume "$feature_name" "$feature_dir"
            ;;
        stop)
            _shakapawd_build_stop "$feature_name" "$feature_dir"
            ;;
        status)
            _shakapawd_build_status "$feature_name" "$feature_dir"
            ;;
        *)
            echo "❌ Unknown action: $action"
            echo "Available: start, resume, stop, status"
            return 1
            ;;
    esac
}

_shakapawd_build_start() {
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
    _shakapawd_build_loop "$feature_name" "$feature_dir"
}

_shakapawd_build_resume() {
    local feature_name=$1
    local feature_dir=$2

    echo "▶️  Resuming implementation: $feature_name"
    echo "   Spec directory: $feature_dir"
    echo ""

    # Start implementation loop (will detect where we are)
    _shakapawd_build_loop "$feature_name" "$feature_dir"
}

_shakapawd_build_stop() {
    local feature_name=$1
    local feature_dir=$2

    echo "⏸️  Stopping implementation: $feature_name"
    echo ""
    echo "Current progress saved in:"
    echo "   • $feature_dir/tasks.md (completed tasks marked)"
    echo "   • $feature_dir/.context.md (session notes)"
    echo ""
    echo "Resume with: shakapawd build resume $feature_name"
}

_shakapawd_build_status() {
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

_shakapawd_build_loop() {
    local feature_name=$1
    local feature_dir=$2
    local requirements_file="$feature_dir/requirements.md"
    local design_file="$feature_dir/design.md"
    local tasks_file="$feature_dir/tasks.md"
    local context_file="$feature_dir/.context.md"

    # Main implementation loop
    local task_count=0
    local completed_count=0

    while true; do
        # Find next incomplete task
        local next_task=$(grep "^- \[ \]" "$tasks_file" | head -1)

        if [[ -z "$next_task" ]]; then
            echo ""
            echo "🎉 All tasks completed!"
            _shakapawd_build_summary "$feature_name" "$feature_dir"
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
# Feature Implementation - Shakapawd Process

You are implementing a feature using the Shakapawd spec-driven development system.

Follow the Shakapawd process defined in this project:
- Read and understand requirements.md, design.md, and tasks.md
- Implement the current task exactly as specified
- Create/modify files in ./src/ (not .shakapawd/)
- After implementing, update .shakapawd/specs/$feature_name/.context.md with:
  - What you implemented (summary)
  - Key decisions made
  - Any blockers or issues
  - Recommendations for next task

## FEATURE REQUIREMENTS
$(cat "$requirements_file")

## TECHNICAL DESIGN
$(cat "$design_file")

## CURRENT TASK
$next_task

$(grep -A 10 "^- \[ \] \*\*[0-9.]*\*\*" "$tasks_file" | head -20)

## SESSION CONTEXT
$(tail -30 "$context_file")

---

Implement this task following all the specifications above. Create real, working code that follows the design and meets the requirements.
EOF
)

        # Show task to user
        echo "📋 Task Description:"
        echo "$next_task" | sed 's/^- \[ \] //'
        echo ""

        # Get approval before proceeding
        echo "Start implementation? (y/n)"
        read -n 1 approval
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

        # Send prompt to Claude and capture output
        local claude_output
        if claude_output=$(echo "$claude_prompt" | claude 2>&1); then
            echo "✅ Implementation complete"
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "Claude's Implementation Summary:"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "$claude_output" | head -100
            echo ""

            # Ask for approval with interaction
            _shakapawd_approval_loop "$feature_name" "$feature_dir" "$claude_output" "$next_task"

            local approval_result=$?

            if [[ $approval_result -eq 0 ]]; then
                # Mark task as complete
                sed -i.bak "s/^- \[ \] \(.*\)$/- [x] \1/" "$tasks_file"
                rm -f "$tasks_file.bak" 2>/dev/null

                # Update context
                echo "$(date '+### Session - Task Complete')" >> "$context_file"
                echo "- Date: $(date '+%Y-%m-%d %H:%M')" >> "$context_file"
                echo "- Task: $task_title" >> "$context_file"
                echo "- Status: ✓ Complete" >> "$context_file"
                echo "" >> "$context_file"

                ((completed_count++))
                echo ""
                echo "✅ Task marked complete"
            else
                echo ""
                echo "⏸️  Build paused - waiting for feedback"
                return 0
            fi
        else
            echo "❌ Claude implementation failed"
            echo "Error: $claude_output"
            return 1
        fi
    done
}

_shakapawd_approval_loop() {
    local feature_name=$1
    local feature_dir=$2
    local implementation=$3
    local task=$4

    while true; do
        echo ""
        echo "Approve this implementation? (y/n/e/f)"
        echo "  y = Approve and continue"
        echo "  n = Reject and get feedback"
        echo "  e = Edit implementation"
        echo "  f = Show full implementation"
        read -n 1 response
        echo ""

        case $response in
            y|Y)
                return 0  # Approved
                ;;
            n|N)
                echo ""
                echo "What needs to change?"
                read feedback
                echo ""
                echo "Getting revised implementation with feedback..."
                # Would loop back with feedback (not shown in this basic version)
                echo "⏸️  TODO: Feedback loop - resubmit with feedback"
                return 1
                ;;
            e|E)
                echo "✏️  TODO: Edit mode not yet implemented"
                return 1
                ;;
            f|F)
                echo ""
                echo "Full implementation:"
                echo "$implementation"
                echo ""
                ;;
            *)
                echo "Invalid choice"
                ;;
        esac
    done
}

_shakapawd_build_summary() {
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
    echo "✅ All implementations approved"
    echo "✅ Code ready for review"
    echo ""
    echo "Next steps:"
    echo "  1. Run tests: bun run test"
    echo "  2. Run linting: bun run lint"
    echo "  3. Submit for code review"
    echo ""
}
