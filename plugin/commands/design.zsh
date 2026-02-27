#!/usr/bin/env zsh
# shakapawd design - Edit design.md for a feature

shakapawd_design() {
    local feature_name=${1}
    local action=${2}
    local shakapawd_dir=".shakapawed"
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

    echo "📐 Editing design for: $feature_name"
    echo "   File: $design_file"
    echo ""

    ${EDITOR:-vim} "$design_file"

    echo ""
    echo "✅ Design updated"
    echo ""
    echo "Next steps:"
    echo "   • Get tech lead approval"
    echo "   • Update STATUS.md with approval status"
    echo "   • Then: shakapawd tasks $feature_name"
}
