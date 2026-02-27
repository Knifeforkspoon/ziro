#!/usr/bin/env zsh
# shakapawd feature - Create, edit, or delete features

shakapawd_feature() {
    local action=${1:-create}
    local feature_name=${2}
    local shakapawd_dir=".shakapawd"
    local specs_dir="$shakapawd_dir/specs"
    local templates_dir="$shakapawd_dir/templates"

    # Validate shakapawd is initialized
    if [[ ! -d "$shakapawd_dir" ]]; then
        echo "❌ Shakapawd not initialized. Run: shakapawd init"
        return 1
    fi

    case $action in
        create)
            if [[ -z "$feature_name" ]]; then
                echo "❌ Feature name required: shakapawd feature create [name]"
                return 1
            fi

            local feature_dir="$specs_dir/$feature_name"

            if [[ -d "$feature_dir" ]]; then
                echo "❌ Feature '$feature_name' already exists"
                return 1
            fi

            echo "🎯 Creating feature: $feature_name"
            echo ""

            # Build Claude prompt for interactive feature creation
            local claude_prompt=$(cat <<EOF
You are guiding the creation of a new feature using the Shakapawd process.

Read $shakapawd_dir/GETTING_STARTED.md for process guidance, then help the user create a feature specification for: **$feature_name**

Conduct an interactive conversation to gather requirements, then output the complete requirements.md file.

Output format:
\`\`\`markdown
### FILE: requirements.md
[complete requirements.md content]
\`\`\`

Start the interactive conversation now.
EOF
)

            # Invoke Claude interactively
            echo "$claude_prompt" | claude
            ;;

        edit)
            if [[ -z "$feature_name" ]]; then
                echo "❌ Feature name required: shakapawd feature edit [name]"
                return 1
            fi

            local feature_dir="$specs_dir/$feature_name"
            if [[ ! -d "$feature_dir" ]]; then
                echo "❌ Feature '$feature_name' not found"
                return 1
            fi

            echo "📂 Feature: $feature_name"
            echo ""
            echo "Choose file to edit:"
            echo "  1) requirements.md"
            echo "  2) design.md"
            echo "  3) tasks.md"
            echo ""
            read -p "Selection (1-3): " choice

            case $choice in
                1) ${EDITOR:-vim} "$feature_dir/requirements.md" ;;
                2) ${EDITOR:-vim} "$feature_dir/design.md" ;;
                3) ${EDITOR:-vim} "$feature_dir/tasks.md" ;;
                *) echo "Invalid choice" ;;
            esac
            ;;

        delete)
            if [[ -z "$feature_name" ]]; then
                echo "❌ Feature name required: shakapawd feature delete [name]"
                return 1
            fi

            local feature_dir="$specs_dir/$feature_name"
            if [[ ! -d "$feature_dir" ]]; then
                echo "❌ Feature '$feature_name' not found"
                return 1
            fi

            echo "⚠️  This will delete feature '$feature_name'"
            read -p "Are you sure? (y/N): " -n 1 confirm
            echo ""

            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                rm -rf "$feature_dir"
                echo "✅ Feature '$feature_name' deleted"
            else
                echo "Cancelled"
            fi
            ;;

        *)
            echo "❌ Unknown action: $action"
            echo "Available: create, edit, delete"
            return 1
            ;;
    esac
}
