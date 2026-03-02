#!/usr/bin/env zsh
# ziro step - Generate and refine implementation tasks (transparently creates or continues)

source "${0:h}/utils.zsh"

ziro_step() {
    local feature_name=$1
    local specs_dir=".ziro/specs"
    local feature_dir="$specs_dir/$feature_name"
    local tasks_file="$feature_dir/tasks.md"
    local design_file="$feature_dir/design.md"
    local requirements_file="$feature_dir/requirements.md"

    ziro_validate_initialized || return 1
    [[ -z "$feature_name" ]] && echo "❌ Feature name required: ziro step [name]" && return 1

    # Check that design is approved first
    [[ ! -f "$design_file" ]] && echo "❌ Design not found. Create design first: ziro plan $feature_name" && return 1

    local design_status=$(ziro_get_approval_status "$design_file")
    [[ "$design_status" != "approved" ]] && echo "❌ Design must be approved first. Approve in: $feature_dir/design.md" && return 1

    # File doesn't exist - create new tasks
    [[ ! -f "$tasks_file" ]] && _ziro_step_create "$feature_name" "$requirements_file" "$design_file" "$tasks_file" && return 0

    # File exists - check if we can edit it
    local approval_status=$(ziro_get_approval_status "$tasks_file")
    [[ "$approval_status" != "approved" ]] && _ziro_step_edit "$feature_name" "$tasks_file" && return 0

    # Approved - check for --force flag
    ziro_parse_force_flag "$@" || { echo "❌ Tasks already approved. Use --force to edit"; return 1; }
    echo "⚠️  Tasks already approved - proceeding with --force"

    _ziro_step_edit "$feature_name" "$tasks_file"
}

_ziro_step_create() {
    local feature_name=$1
    local requirements_file=$2
    local design_file=$3
    local tasks_file=$4

    echo "✅ Generating implementation tasks: $feature_name"
    echo ""

    local claude_prompt=$(cat <<EOF
You are guiding the creation of implementation tasks using the Ziro process.

Read .ziro/GETTING_STARTED.md for process guidance.
Read $requirements_file and $design_file for context on this feature.

Help the user create a tasks.md file for: **$feature_name**

Conduct an interactive conversation to break down the work into phases and tasks, then output the complete tasks.md file.

Output format:
\`\`\`markdown
### FILE: tasks.md
[complete tasks.md content]
\`\`\`

Start the interactive conversation now.
EOF
)

    echo "$claude_prompt" | claude
}

_ziro_step_edit() {
    local feature_name=$1
    local tasks_file=$2

    echo "✅ Refining implementation tasks: $feature_name"
    echo ""

    local claude_prompt=$(cat <<EOF
You are helping refine and improve the tasks for: **$feature_name**

Current tasks:
$(cat "$tasks_file")

Conduct an interactive conversation about improvements, clarifications, or changes needed. Then output the complete updated tasks.md file.

Output format:
\`\`\`markdown
### FILE: tasks.md
[complete updated tasks.md content]
\`\`\`

Start the conversation now.
EOF
)

    echo "$claude_prompt" | claude
}
