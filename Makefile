.PHONY: help init feature list-features clean-specs

help:
	@echo "Shakapawd - Spec-Driven Development System"
	@echo ""
	@echo "Usage:"
	@echo "  make init [template=front-end]        Initialize shakapawd in current repo"
	@echo "  make feature [name=NAME]              Create new feature spec"
	@echo "  make list-features                    List all existing feature specs"
	@echo "  make help                             Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make init                             # Initialize with front-end templates"
	@echo "  make init template=back-end           # Initialize with back-end templates (future)"
	@echo "  make feature name=tower-search        # Create feature spec for 'tower-search'"
	@echo "  make feature name=user-auth           # Create feature spec for 'user-auth'"
	@echo ""

# Default template is front-end
TEMPLATE ?= front-end
FEATURE_NAME ?=

# Paths
SHAKAPAWD_DIR := .shakapawed
SPECS_DIR := $(SHAKAPAWD_DIR)/specs
TEMPLATES_DIR := $(SHAKAPAWD_DIR)/templates
SHAKAPAWD_REPO := https://github.com/shakalabs/shakapawd.git

init:
	@if [ -d "$(SHAKAPAWD_DIR)" ]; then \
		echo "❌ Shakapawd already initialized in $(SHAKAPAWD_DIR)"; \
		exit 1; \
	fi
	@echo "📦 Initializing Shakapawd with $(TEMPLATE) templates..."
	@mkdir -p $(SPECS_DIR)
	@mkdir -p $(TEMPLATES_DIR)
	@echo "📂 Created directory structure"
	@./scripts/setup-templates.sh $(TEMPLATE)
	@echo "✅ Shakapawd initialized successfully!"
	@echo ""
	@echo "📖 Next steps:"
	@echo "   1. Read: .shakapawed/GETTING_STARTED.md"
	@echo "   2. Create feature: make feature name=my-feature"
	@echo "   3. Check templates: ls -la .shakapawed/templates/"

feature:
	@if [ -z "$(FEATURE_NAME)" ]; then \
		echo "❌ Feature name required: make feature name=FEATURE_NAME"; \
		exit 1; \
	fi
	@if [ ! -d "$(SHAKAPAWD_DIR)" ]; then \
		echo "❌ Shakapawd not initialized. Run: make init"; \
		exit 1; \
	fi
	@if [ -d "$(SPECS_DIR)/$(FEATURE_NAME)" ]; then \
		echo "❌ Feature '$(FEATURE_NAME)' already exists"; \
		exit 1; \
	fi
	@echo "🎯 Creating feature spec: $(FEATURE_NAME)"
	@./scripts/create-feature.sh $(FEATURE_NAME)
	@echo "✅ Feature created successfully!"
	@echo ""
	@echo "📝 Next steps:"
	@echo "   1. Edit: .shakapawed/specs/$(FEATURE_NAME)/requirements.md"
	@echo "   2. Get approval from product owner"
	@echo "   3. Then: .shakapawed/specs/$(FEATURE_NAME)/design.md"

list-features:
	@if [ ! -d "$(SPECS_DIR)" ]; then \
		echo "❌ No specs directory found. Run: make init"; \
		exit 1; \
	fi
	@if [ ! "$(shell ls -1 $(SPECS_DIR) 2>/dev/null)" ]; then \
		echo "📭 No features found"; \
		exit 0; \
	fi
	@echo "📋 Existing Feature Specs:"
	@echo ""
	@for dir in $(SPECS_DIR)/*/; do \
		feature=$$(basename $$dir); \
		status=""; \
		if [ -f "$$dir/requirements.md" ] && grep -q "Approved" "$$dir/requirements.md" 2>/dev/null; then \
			status=" ✓ req"; \
		fi; \
		if [ -f "$$dir/design.md" ] && grep -q "Approved" "$$dir/design.md" 2>/dev/null; then \
			status="$$status ✓ des"; \
		fi; \
		if [ -f "$$dir/tasks.md" ] && grep -q "Approved" "$$dir/tasks.md" 2>/dev/null; then \
			status="$$status ✓ tsk"; \
		fi; \
		printf "  • %-30s [%s ]\n" "$$feature" "$$status"; \
	done
	@echo ""

clean-specs:
	@echo "⚠️  This will delete all feature specs"
	@read -p "Are you sure? (y/N) " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -rf $(SPECS_DIR)/*; \
		echo "✅ Feature specs cleared"; \
	else \
		echo "Cancelled"; \
	fi

.DEFAULT_GOAL := help
