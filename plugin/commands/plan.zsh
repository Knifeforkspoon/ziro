#!/usr/bin/env zsh
# ziro plan - Create design.md for a feature

source "${0:h}/utils.zsh"

ziro_plan_create() {
    local feature_name=$1
    local specs_dir=".ziro/specs"
    local feature_dir="$specs_dir/$feature_name"

    ziro_validate_feature "$feature_name" "plan create" || return 1

    local requirements_file="$feature_dir/requirements.md"
    ziro_check_dependency "$requirements_file" "Requirements" "$2" || return 1

    echo "📐 Creating design for: $feature_name"
    echo ""

    local claude_prompt
    claude_prompt=$(cat <<EOF
You are guiding the creation of a technical design using the Shakapawd process.

Read .ziro/GETTING_STARTED.md for process guidance.
Read $feature_dir/requirements.md for context on this feature.

Help the user create a design.md file for: **$feature_name**

Conduct an interactive conversation about architecture, components, data models, and testing, then output the complete design.md file.

Output format:
\`\`\`markdown
### FILE: design.md
[complete design.md content]
\`\`\`

Start the interactive conversation now.
EOF
)

    echo "$claude_prompt" | claude
}

ziro_plan_edit() {
    local feature_name=$1
    local specs_dir=".ziro/specs"
    local feature_dir="$specs_dir/$feature_name"

    ziro_validate_feature "$feature_name" "plan edit" || return 1

    local design_file="$feature_dir/design.md"
    ziro_check_approval "$design_file" "Design" "$2" || return 1

    echo "📐 Refining design for: $feature_name"
    echo ""

    local claude_prompt
    claude_prompt=$(cat <<EOF
You are helping refine and improve the design for: **$feature_name**

Current design:
$(cat "$design_file")

Conduct an interactive conversation about improvements, clarifications, or changes needed. Then output the complete updated design.md file.

Output format:
\`\`\`markdown
### FILE: design.md
[complete updated design.md content]
\`\`\`

Start the conversation now.
EOF
)

    echo "$claude_prompt" | claude
}

ziro_plan() {
    local action=${1:-create}
    local feature_name=${2}

    ziro_validate_initialized || return 1

    case $action in
        create) ziro_plan_create "$feature_name" "$3" ;;
        edit) ziro_plan_edit "$feature_name" "$3" ;;
        *) echo "❌ Unknown action: $action"; echo "Available: create, edit"; return 1 ;;
    esac
}
