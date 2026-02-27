#!/usr/bin/env zsh
# shakapawd tasks - Edit tasks.md for a feature

shakapawd_tasks() {
    local feature_name=${1}
    local action=${2}
    local shakapawd_dir=".shakapawd"
    local specs_dir="$shakapawd_dir/specs"

    # Validate shakapawd is initialized
    if [[ ! -d "$shakapawd_dir" ]]; then
        echo "❌ Shakapawd not initialized. Run: shakapawd init"
        return 1
    fi

    # Handle: shakapawd tasks edit [name] or shakapawd tasks [name]
    if [[ "$action" == "edit" ]]; then
        feature_name=$action
    elif [[ -z "$feature_name" ]]; then
        echo "❌ Feature name required: shakapawd tasks [feature-name]"
        return 1
    fi

    local feature_dir="$specs_dir/$feature_name"
    local tasks_file="$feature_dir/tasks.md"

    if [[ ! -d "$feature_dir" ]]; then
        echo "❌ Feature '$feature_name' not found"
        echo "Available features:"
        ls -1 "$specs_dir" 2>/dev/null | grep -v "^\.gitkeep$" | sed 's/^/  • /'
        return 1
    fi

    if [[ ! -f "$tasks_file" ]]; then
        echo "❌ Tasks file not found: $tasks_file"
        return 1
    fi

    echo "✅ Creating tasks for: $feature_name"
    echo ""

    # Build Claude prompt for interactive tasks creation
    local claude_prompt=$(cat <<EOF
You are guiding the creation of implementation tasks using the Shakapawd process.

Read $shakapawd_dir/GETTING_STARTED.md for process guidance.
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

            # Invoke Claude interactively
            echo "$claude_prompt" | claude
}
