#!/usr/bin/env zsh
# shakapawd feature - Create, edit, or delete features

shakapawd_feature() {
    local action=${1:-create}
    local feature_name=${2}
    local shakapawd_dir=".shakapawed"
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

            echo "🎯 Creating feature spec: $feature_name"

            # Create feature directory
            mkdir -p "$feature_dir"
            echo "📁 Created $feature_dir"

            # Determine which templates to use
            local fe_templates="$templates_dir/front-end-templates"
            local be_templates="$templates_dir/back-end-templates"

            # Copy requirements
            if [[ -f "$fe_templates/requirements_template_frontend.md" ]]; then
                cp "$fe_templates/requirements_template_frontend.md" \
                   "$feature_dir/requirements.md"
                echo "📋 Created requirements.md"
            elif [[ -f "$templates_dir/requirements_template.md" ]]; then
                cp "$templates_dir/requirements_template.md" \
                   "$feature_dir/requirements.md"
                echo "📋 Created requirements.md"
            fi

            # Copy design
            if [[ -f "$fe_templates/design_template_sveltekit.md" ]]; then
                cp "$fe_templates/design_template_sveltekit.md" \
                   "$feature_dir/design.md"
                echo "📐 Created design.md"
            elif [[ -f "$templates_dir/design_template.md" ]]; then
                cp "$templates_dir/design_template.md" \
                   "$feature_dir/design.md"
                echo "📐 Created design.md"
            fi

            # Copy tasks
            if [[ -f "$fe_templates/tasks_template_frontend.md" ]]; then
                cp "$fe_templates/tasks_template_frontend.md" \
                   "$feature_dir/tasks.md"
                echo "✅ Created tasks.md"
            elif [[ -f "$templates_dir/tasks_template.md" ]]; then
                cp "$templates_dir/tasks_template.md" \
                   "$feature_dir/tasks.md"
                echo "✅ Created tasks.md"
            fi


            echo ""
            echo "✅ Feature '$feature_name' created successfully!"
            echo ""
            echo "📝 Next steps:"
            echo "   1. Edit: shakapawd design $feature_name"
            echo "   2. Or manually: $feature_dir/requirements.md"
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
