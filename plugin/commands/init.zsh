#!/usr/bin/env zsh
# ziro init - Initialize ziro in current repo

ziro_init() {
    local template=${1}
    local ziro_dir=".ziro"
    local templates_dir="$ziro_dir/templates"
    local specs_dir="$ziro_dir/specs"

    # Check if already initialized
    if [[ -d "$ziro_dir" ]]; then
        echo "❌ Ziro already initialized in $ziro_dir"
        return 1
    fi

    # Dynamically discover available templates from plugin
    local plugin_templates_dir="$ZIRO_REPO_DIR/.ziro/templates"

    if [[ ! -d "$plugin_templates_dir" ]]; then
        echo "❌ Templates directory not found in plugin"
        return 1
    fi

    # Scan for *-templates directories and extract template names
    local available_templates=""
    local template_count=0

    for template_dir in "$plugin_templates_dir"/*-templates; do
        if [[ -d "$template_dir" ]]; then
            local template_name="${template_dir##*/}"
            template_name="${template_name%-templates}"

            if [[ -z "$available_templates" ]]; then
                available_templates="$template_name"
            else
                available_templates="$available_templates $template_name"
            fi
            ((template_count++))
        fi
    done

    # If no templates found, error
    if [[ $template_count -eq 0 ]]; then
        echo "❌ No templates found in plugin"
        return 1
    fi

    # If template provided, validate it
    if [[ -n "$template" ]]; then
        local found=0
        for t in $available_templates; do
            if [[ "$t" == "$template" ]]; then
                found=1
                break
            fi
        done

        if [[ $found -eq 0 ]]; then
            echo "❌ Template '$template' not found"
            echo ""
            template=""
        fi
    fi

    # If no valid template, show menu
    if [[ -z "$template" ]]; then
        echo "📦 Select template for Ziro initialization"
        echo ""

        local idx=1
        for t in $available_templates; do
            echo "  $idx) $t"
            ((idx++))
        done

        echo ""
        printf "Select template (1-$template_count): "
        read selection

        if [[ ! "$selection" =~ ^[0-9]+$ ]] || \
           [[ $selection -lt 1 ]] || \
           [[ $selection -gt $template_count ]]; then
            echo "❌ Invalid selection"
            return 1
        fi

        # Extract the selected template
        local idx=1
        for t in $available_templates; do
            if [[ $idx -eq $selection ]]; then
                template="$t"
                break
            fi
            ((idx++))
        done
    fi

    echo ""
    echo "📦 Initializing Ziro with $template templates..."

    # Create directory structure
    mkdir -p "$specs_dir"
    mkdir -p "$templates_dir"
    echo "📂 Created directory structure"

    # Copy templates based on type
    case $template in
        front-end)
            mkdir -p "$templates_dir/front-end-templates"

            # Copy from plugin templates
            local plugin_templates="$ZIRO_REPO_DIR/.ziro/templates/front-end-templates"

            if [[ -d "$plugin_templates" ]]; then
                cp "$plugin_templates/requirements_template_frontend.md" \
                   "$templates_dir/front-end-templates/" 2>/dev/null || true
                cp "$plugin_templates/design_template_sveltekit.md" \
                   "$templates_dir/front-end-templates/" 2>/dev/null || true
                cp "$plugin_templates/tasks_template_frontend.md" \
                   "$templates_dir/front-end-templates/" 2>/dev/null || true
            fi

            # Copy guide
            if [[ -f "$ZIRO_REPO_DIR/.ziro/templates/FRONTEND_TEMPLATES_GUIDE.md" ]]; then
                cp "$ZIRO_REPO_DIR/.ziro/templates/FRONTEND_TEMPLATES_GUIDE.md" \
                   "$templates_dir/"
            fi

            # Copy getting started
            if [[ -f "$ZIRO_REPO_DIR/.ziro/GETTING_STARTED.md" ]]; then
                cp "$ZIRO_REPO_DIR/.ziro/GETTING_STARTED.md" \
                   "$ziro_dir/"
            fi

            echo "✓ Front-end templates ready"
            ;;

        back-end)
            mkdir -p "$templates_dir/back-end-templates"
            echo "✓ Back-end template directory created (templates coming soon)"
            ;;

        *)
            echo "❌ Unknown template type: $template"
            echo "Available: front-end, back-end"
            return 1
            ;;
    esac

    # Create .gitkeep
    touch "$specs_dir/.gitkeep"

    echo ""
    echo "✅ Ziro initialized successfully!"
    echo ""
    echo "📖 Next steps:"
    echo "   1. Read: $ziro_dir/GETTING_STARTED.md"
    echo "   2. Create feature: ziro req create my-feature"
    echo "   3. View templates: ls -la $templates_dir/"
}
