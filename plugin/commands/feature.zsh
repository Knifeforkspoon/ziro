#!/usr/bin/env zsh
# shakapawd feature - Create, edit, or delete features

source "${0:h}/utils.zsh"

shakapawd_feature_create() {
    local feature_name=$1
    local specs_dir=".shakapawd/specs"
    local feature_dir="$specs_dir/$feature_name"

    [[ -z "$feature_name" ]] && echo "❌ Feature name required: shakapawd feature create [name]" && return 1

    mkdir -p "$feature_dir"

    local requirements_file="$feature_dir/requirements.md"
    shakapawd_check_approval "$requirements_file" "Requirements" "$2" || return 1

    echo "🎯 Creating feature: $feature_name"
    echo ""

    local claude_prompt
    claude_prompt=$(cat <<EOF
You are guiding the creation of a new feature using the Shakapawd process.

Read .shakapawd/GETTING_STARTED.md for process guidance, then help the user create a feature specification for: **$feature_name**

Conduct an interactive conversation to gather requirements, then output the complete requirements.md file.

Output format:
\`\`\`markdown
### FILE: requirements.md
[complete requirements.md content]
\`\`\`

Start the interactive conversation now.
EOF
)

    echo "$claude_prompt" | claude
}

shakapawd_feature_edit() {
    local feature_name=$1
    local specs_dir=".shakapawd/specs"
    local feature_dir="$specs_dir/$feature_name"

    shakapawd_validate_feature "$feature_name" "feature edit" || return 1

    local requirements_file="$feature_dir/requirements.md"
    shakapawd_check_approval "$requirements_file" "Requirements" "$2" || return 1

    echo "🎯 Refining requirements for: $feature_name"
    echo ""

    local claude_prompt
    claude_prompt=$(cat <<EOF
You are helping refine and improve requirements for: **$feature_name**

Current requirements:
$(cat "$requirements_file")

Conduct an interactive conversation about improvements, clarifications, or changes needed. Then output the complete updated requirements.md file.

Output format:
\`\`\`markdown
### FILE: requirements.md
[complete updated requirements.md content]
\`\`\`

Start the conversation now.
EOF
)

    echo "$claude_prompt" | claude
}

shakapawd_feature_delete() {
    local feature_name=$1
    local specs_dir=".shakapawd/specs"
    local feature_dir="$specs_dir/$feature_name"

    shakapawd_validate_feature "$feature_name" "feature delete" || return 1

    local tasks_file="$feature_dir/tasks.md"
    if [[ -f "$tasks_file" ]]; then
        shakapawd_check_approval "$tasks_file" "Tasks" "$2" || return 1
    fi

    echo "⚠️  This will delete feature '$feature_name'"
    read -r -p "Are you sure? (y/N): " -n 1 confirm
    echo ""

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -rf "$feature_dir"
        echo "✅ Feature '$feature_name' deleted"
    else
        echo "Cancelled"
    fi
}

shakapawd_feature() {
    local action=${1:-create}
    local feature_name=${2}

    shakapawd_validate_initialized || return 1

    case $action in
        create) shakapawd_feature_create "$feature_name" "$3" ;;
        edit) shakapawd_feature_edit "$feature_name" "$3" ;;
        delete) shakapawd_feature_delete "$feature_name" "$3" ;;
        *) echo "❌ Unknown action: $action"; echo "Available: create, edit, delete"; return 1 ;;
    esac
}
