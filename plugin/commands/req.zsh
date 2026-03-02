#!/usr/bin/env zsh
# ziro req - Gather and refine requirements (transparently creates or continues)

source "${0:h}/utils.zsh"

ziro_req() {
    local feature_name=$1
    local specs_dir=".ziro/specs"
    local feature_dir="$specs_dir/$feature_name"
    local requirements_file="$feature_dir/requirements.md"

    ziro_validate_initialized || return 1
    [[ -z "$feature_name" ]] && echo "❌ Feature name required: ziro req [name]" && return 1

    mkdir -p "$feature_dir"

    # File doesn't exist - create new requirements
    [[ ! -f "$requirements_file" ]] && _ziro_req_create "$feature_name" "$requirements_file" && return 0

    # File exists - check if we can edit it
    local approval_status=$(ziro_get_approval_status "$requirements_file")
    [[ "$approval_status" != "approved" ]] && _ziro_req_edit "$feature_name" "$requirements_file" && return 0

    # Approved - check for --force flag
    ziro_parse_force_flag "$@" || { echo "❌ Requirements already approved. Use --force to edit"; return 1; }
    echo "⚠️  Requirements already approved - proceeding with --force"

    _ziro_req_edit "$feature_name" "$requirements_file"
}

_ziro_req_create() {
    local feature_name=$1
    local requirements_file=$2

    echo "🎯 Gathering requirements: $feature_name"
    echo ""

    local claude_prompt=$(cat <<EOF
You are guiding the creation of a new feature using the Ziro process.

Read .ziro/GETTING_STARTED.md for process guidance, then help the user create a feature specification for: **$feature_name**

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

_ziro_req_edit() {
    local feature_name=$1
    local requirements_file=$2

    echo "🎯 Refining requirements: $feature_name"
    echo ""

    local claude_prompt=$(cat <<EOF
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
