#!/usr/bin/env zsh
# ziro step - Create tasks.md for a feature

source "${0:h}/utils.zsh"

ziro_step_create() {
    local feature_name=$1
    local specs_dir=".ziro/specs"
    local feature_dir="$specs_dir/$feature_name"

    ziro_validate_feature "$feature_name" "step create" || return 1

    local design_file="$feature_dir/design.md"
    ziro_check_dependency "$design_file" "Design" "$2" || return 1

    echo "✅ Creating tasks for: $feature_name"
    echo ""

    local claude_prompt
    claude_prompt=$(cat <<EOF
You are guiding the creation of implementation tasks using the Shakapawd process.

Read .ziro/GETTING_STARTED.md for process guidance.
Read $feature_dir/requirements.md and $feature_dir/design.md for context on this feature.

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

ziro_step_edit() {
    local feature_name=$1
    local specs_dir=".ziro/specs"
    local feature_dir="$specs_dir/$feature_name"

    ziro_validate_feature "$feature_name" "step edit" || return 1

    local tasks_file="$feature_dir/tasks.md"
    ziro_check_approval "$tasks_file" "Tasks" "$2" || return 1

    echo "✅ Refining tasks for: $feature_name"
    echo ""

    local claude_prompt
    claude_prompt=$(cat <<EOF
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

ziro_step() {
    local action=${1:-create}
    local feature_name=${2}

    ziro_validate_initialized || return 1

    case $action in
        create) ziro_step_create "$feature_name" "$3" ;;
        edit) ziro_step_edit "$feature_name" "$3" ;;
        *) echo "❌ Unknown action: $action"; echo "Available: create, edit"; return 1 ;;
    esac
}
