#!/usr/bin/env zsh
# shakapawd tasks - Edit tasks.md for a feature

shakapawd_tasks() {
    local feature_name=${1}
    local action=${2}
    local shakapawd_dir=".shakapawed"
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

    echo "✅ Editing tasks for: $feature_name"
    echo "   File: $tasks_file"
    echo ""

    ${EDITOR:-vim} "$tasks_file"

    echo ""
    echo "✅ Tasks updated"
    echo ""
    echo "Next steps:"
    echo "   • Get team approval"
    echo "   • Then: shakapawd build start $feature_name"
}
