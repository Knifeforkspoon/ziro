#!/usr/bin/env zsh
# Shared utilities for ziro commands

# Validate that ziro is initialized
ziro_validate_initialized() {
    local ziro_dir=".ziro"
    if [[ ! -d "$ziro_dir" ]]; then
        echo "❌ Ziro not initialized. Run: ziro init"
        return 1
    fi
}

# Parse --force flag from arguments
# Usage: ziro_parse_force_flag "$@"
# Returns 0 if flag is present, 1 if not
ziro_parse_force_flag() {
    for arg in "$@"; do
        if [[ "$arg" == "--force" ]]; then
            return 0
        fi
    done
    return 1
}

# Get approval status of a file
# Usage: ziro_get_approval_status "path/to/file.md"
# Outputs: "approved", "draft", "none", or "missing"
ziro_get_approval_status() {
    local file=$1

    [[ ! -f "$file" ]] && echo "missing" && return 0

    if ! grep -q "## Approval Status" "$file"; then
        echo "none"
        return 0
    fi

    if grep -A20 "## Approval Status" "$file" | grep -qi "APPROVED"; then
        echo "approved"
        return 0
    fi

    echo "draft"
}

# Check if a file has approval status (for editing/creating)
# Usage: ziro_check_approval "path/to/file.md" "phase-name" [--force]
# Returns 0 if not approved or force flag present
# Returns 1 if already approved and no force flag
ziro_check_approval() {
    local file=$1
    local phase=$2
    local force_flag=$3
    local approval_status

    approval_status=$(ziro_get_approval_status "$file")

    [[ "$approval_status" == "missing" || "$approval_status" == "none" || "$approval_status" == "draft" ]] && return 0

    [[ "$force_flag" == "--force" ]] && echo "⚠️  $phase already approved - proceeding with --force" && return 0

    echo "❌ $phase already approved"
    echo "Run with --force to update anyway"
    return 1
}

# Check if a dependency phase is approved (for moving to next phase)
# Usage: ziro_check_dependency "path/to/file.md" "phase-name" [--force]
# Returns 0 if approved or force flag present
# Returns 1 if missing/not approved and no force flag
ziro_check_dependency() {
    local file=$1
    local phase=$2
    local force_flag=$3
    local approval_status

    approval_status=$(ziro_get_approval_status "$file")

    [[ "$approval_status" == "missing" ]] && echo "❌ $phase file not found: $file" && return 1
    [[ "$approval_status" == "approved" ]] && return 0
    [[ "$force_flag" == "--force" ]] && echo "⚠️  Proceeding with --force" && return 0

    echo "❌ $phase not approved"
    echo "Run with --force to proceed anyway"
    return 1
}

# List available features
# Usage: ziro_list_features
ziro_list_features() {
    local specs_dir=".ziro/specs"
    echo "Available features:"
    for item in "$specs_dir"/*; do
        [[ -d "$item" && "$(basename "$item")" != ".gitkeep" ]] && echo "  • $(basename "$item")"
    done
}

# Validate feature name and directory exist
# Usage: ziro_validate_feature "feature-name" "command-name"
# Returns 0 if valid, 1 if not
ziro_validate_feature() {
    local feature_name=$1
    local command_name=$2

    [[ -z "$feature_name" ]] && echo "❌ Feature name required: ziro $command_name [name]" && return 1

    local specs_dir=".ziro/specs"
    local feature_dir="$specs_dir/$feature_name"

    [[ ! -d "$feature_dir" ]] && echo "❌ Feature '$feature_name' not found" && return 1

    return 0
}
