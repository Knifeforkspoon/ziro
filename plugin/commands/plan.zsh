#!/usr/bin/env zsh
# ziro plan - Create and refine architectural design (transparently creates or continues)

source "${0:h}/utils.zsh"

ziro_plan() {
    local feature_name=$1
    local specs_dir=".ziro/specs"
    local feature_dir="$specs_dir/$feature_name"
    local design_file="$feature_dir/design.md"
    local requirements_file="$feature_dir/requirements.md"

    ziro_validate_initialized || return 1
    [[ -z "$feature_name" ]] && echo "❌ Feature name required: ziro plan [name]" && return 1

    # Check that requirements are approved first
    [[ ! -f "$requirements_file" ]] && echo "❌ Requirements not found. Create requirements first: ziro req $feature_name" && return 1

    local req_status=$(ziro_get_approval_status "$requirements_file")
    [[ "$req_status" != "approved" ]] && echo "❌ Requirements must be approved first. Approve in: $feature_dir/requirements.md" && return 1

    # File doesn't exist - create new design
    [[ ! -f "$design_file" ]] && _ziro_plan_create "$feature_name" "$requirements_file" "$design_file" && return 0

    # File exists - check if we can edit it
    local approval_status=$(ziro_get_approval_status "$design_file")
    [[ "$approval_status" != "approved" ]] && _ziro_plan_edit "$feature_name" "$design_file" && return 0

    # Approved - check for --force flag
    ziro_parse_force_flag "$@" || { echo "❌ Design already approved. Use --force to edit"; return 1; }
    echo "⚠️  Design already approved - proceeding with --force"

    _ziro_plan_edit "$feature_name" "$design_file"
}

_ziro_plan_create() {
    local feature_name=$1
    local requirements_file=$2
    local design_file=$3

    echo "📐 Creating architectural design: $feature_name"
    echo ""

    local claude_prompt=$(cat <<EOF
You are guiding the creation of a technical design using the Ziro process.

Read .ziro/GETTING_STARTED.md for process guidance.
Read $requirements_file for context on this feature.

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

_ziro_plan_edit() {
    local feature_name=$1
    local design_file=$2

    echo "📐 Refining architectural design: $feature_name"
    echo ""

    local claude_prompt=$(cat <<EOF
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
