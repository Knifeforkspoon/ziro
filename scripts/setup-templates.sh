#!/bin/bash

# setup-templates.sh - Initialize Shakapawd templates in a repo
# Usage: ./scripts/setup-templates.sh [template-type]

TEMPLATE_TYPE=${1:-front-end}
SHAKAPAWD_DIR=".shakapawed"
TEMPLATES_DIR="$SHAKAPAWD_DIR/templates"
SPECS_DIR="$SHAKAPAWD_DIR/specs"

# Copy documentation files
echo "📋 Copying documentation..."
if [ -f "scripts/../.shakapawed/GETTING_STARTED.md" ]; then
    cp "scripts/../.shakapawed/GETTING_STARTED.md" "$SHAKAPAWD_DIR/"
fi

# Create template directory based on template type
echo "📂 Setting up $TEMPLATE_TYPE templates..."

case $TEMPLATE_TYPE in
    front-end)
        mkdir -p "$TEMPLATES_DIR/front-end-templates"

        # Copy from the shakapawd repo templates
        TEMPLATE_SOURCE="scripts/../.shakapawed/templates/front-end-templates"

        if [ -d "$TEMPLATE_SOURCE" ]; then
            cp "$TEMPLATE_SOURCE/requirements_template_frontend.md" \
               "$TEMPLATES_DIR/front-end-templates/" 2>/dev/null || true
            cp "$TEMPLATE_SOURCE/design_template_sveltekit.md" \
               "$TEMPLATES_DIR/front-end-templates/" 2>/dev/null || true
            cp "$TEMPLATE_SOURCE/tasks_template_frontend.md" \
               "$TEMPLATES_DIR/front-end-templates/" 2>/dev/null || true
        fi

        # Copy guide
        if [ -f "scripts/../.shakapawed/templates/FRONTEND_TEMPLATES_GUIDE.md" ]; then
            cp "scripts/../.shakapawed/templates/FRONTEND_TEMPLATES_GUIDE.md" \
               "$TEMPLATES_DIR/"
        fi

        echo "✓ Front-end templates ready"
        ;;

    back-end)
        mkdir -p "$TEMPLATES_DIR/back-end-templates"
        echo "✓ Back-end template directory created (templates coming soon)"
        ;;

    *)
        echo "❌ Unknown template type: $TEMPLATE_TYPE"
        exit 1
        ;;
esac

# Create .gitkeep for specs directory so it's tracked
touch "$SPECS_DIR/.gitkeep"

echo "✅ Templates initialized in $TEMPLATES_DIR"
