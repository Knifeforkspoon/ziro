#!/bin/bash

# create-feature.sh - Create a new feature spec directory
# Usage: ./scripts/create-feature.sh FEATURE_NAME

FEATURE_NAME=$1
SHAKAPAWD_DIR=".shakapawed"
SPECS_DIR="$SHAKAPAWD_DIR/specs"
TEMPLATES_DIR="$SHAKAPAWD_DIR/templates"
FEATURE_DIR="$SPECS_DIR/$FEATURE_NAME"

if [ -z "$FEATURE_NAME" ]; then
    echo "❌ Feature name required"
    echo "Usage: $0 FEATURE_NAME"
    exit 1
fi

if [ ! -d "$SHAKAPAWD_DIR" ]; then
    echo "❌ Shakapawd not initialized. Run: make init"
    exit 1
fi

if [ -d "$FEATURE_DIR" ]; then
    echo "❌ Feature '$FEATURE_NAME' already exists"
    exit 1
fi

# Create feature directory
mkdir -p "$FEATURE_DIR"
echo "📁 Created $FEATURE_DIR"

# Determine which templates to copy based on available templates
FRONT_END_TEMPLATES="$TEMPLATES_DIR/front-end-templates"
BACK_END_TEMPLATES="$TEMPLATES_DIR/back-end-templates"

# Copy requirements template
[ -f "$FRONT_END_TEMPLATES/requirements_template_frontend.md" ] && \
    cp "$FRONT_END_TEMPLATES/requirements_template_frontend.md" "$FEATURE_DIR/requirements.md" && \
    echo "📋 Created requirements.md" && return 0

[ -f "$BACK_END_TEMPLATES/requirements_template_backend.md" ] && \
    cp "$BACK_END_TEMPLATES/requirements_template_backend.md" "$FEATURE_DIR/requirements.md" && \
    echo "📋 Created requirements.md" && return 0

[ -f "$TEMPLATES_DIR/requirements_template.md" ] && \
    cp "$TEMPLATES_DIR/requirements_template.md" "$FEATURE_DIR/requirements.md" && \
    echo "📋 Created requirements.md"

# Copy design template
[ -f "$FRONT_END_TEMPLATES/design_template_sveltekit.md" ] && \
    cp "$FRONT_END_TEMPLATES/design_template_sveltekit.md" "$FEATURE_DIR/design.md" && \
    echo "📐 Created design.md" && return 0

[ -f "$BACK_END_TEMPLATES/design_template_backend.md" ] && \
    cp "$BACK_END_TEMPLATES/design_template_backend.md" "$FEATURE_DIR/design.md" && \
    echo "📐 Created design.md" && return 0

[ -f "$TEMPLATES_DIR/design_template.md" ] && \
    cp "$TEMPLATES_DIR/design_template.md" "$FEATURE_DIR/design.md" && \
    echo "📐 Created design.md"

# Copy tasks template
[ -f "$FRONT_END_TEMPLATES/tasks_template_frontend.md" ] && \
    cp "$FRONT_END_TEMPLATES/tasks_template_frontend.md" "$FEATURE_DIR/tasks.md" && \
    echo "✅ Created tasks.md" && return 0

[ -f "$BACK_END_TEMPLATES/tasks_template_backend.md" ] && \
    cp "$BACK_END_TEMPLATES/tasks_template_backend.md" "$FEATURE_DIR/tasks.md" && \
    echo "✅ Created tasks.md" && return 0

[ -f "$TEMPLATES_DIR/tasks_template.md" ] && \
    cp "$TEMPLATES_DIR/tasks_template.md" "$FEATURE_DIR/tasks.md" && \
    echo "✅ Created tasks.md"

echo ""
echo "✅ Feature '$FEATURE_NAME' created successfully!"
echo ""
echo "Files created:"
echo "  • $FEATURE_DIR/requirements.md"
echo "  • $FEATURE_DIR/design.md"
echo "  • $FEATURE_DIR/tasks.md"
echo ""
echo "Next steps:"
echo "  1. Edit $FEATURE_DIR/requirements.md"
echo "  2. Fill in feature requirements and user stories"
echo "  3. Get approval from product owner"
echo "  4. Proceed to design.md"
