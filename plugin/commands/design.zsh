#!/usr/bin/env zsh
# shakapawd design - Edit design.md for a feature

shakapawd_design() {
    local feature_name=${1}
    local action=${2}
    local shakapawd_dir=".shakapawd"
    local specs_dir="$shakapawd_dir/specs"

    # Validate shakapawd is initialized
    if [[ ! -d "$shakapawd_dir" ]]; then
        echo "❌ Shakapawd not initialized. Run: shakapawd init"
        return 1
    fi

    # Handle: shakapawd design edit [name] or shakapawd design [name]
    if [[ "$action" == "edit" ]]; then
        feature_name=$action
    elif [[ -z "$feature_name" ]]; then
        echo "❌ Feature name required: shakapawd design [feature-name]"
        return 1
    fi

    local feature_dir="$specs_dir/$feature_name"
    local design_file="$feature_dir/design.md"

    if [[ ! -d "$feature_dir" ]]; then
        echo "❌ Feature '$feature_name' not found"
        echo "Available features:"
        ls -1 "$specs_dir" 2>/dev/null | grep -v "^\.gitkeep$" | sed 's/^/  • /'
        return 1
    fi

    if [[ ! -f "$design_file" ]]; then
        echo "❌ Design file not found: $design_file"
        return 1
    fi

    echo "📐 Creating design for: $feature_name"
    echo ""

    # Build Claude prompt for interactive design creation
    local claude_prompt=$(cat <<EOF
You are guiding the creation of a technical design using the Shakapawd process.

Read $shakapawd_dir/GETTING_STARTED.md for process guidance.
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

            # Invoke Claude interactively
            echo "$claude_prompt" | claude
}
