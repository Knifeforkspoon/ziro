#!/usr/bin/env zsh
# Ziro - Zero-Friction Spec-Driven Development System
# Facilitates: init, req, plan, step, ralph, go, status, ls

# Get plugin directory
ZIRO_PLUGIN_DIR="${0:h}"
ZIRO_REPO_DIR="${ZIRO_PLUGIN_DIR}/../"

# Source all command functions
for cmd_file in "$ZIRO_PLUGIN_DIR"/commands/*.zsh; do
    source "$cmd_file"
done

# Main ziro dispatcher
ziro() {
    local command=$1
    shift

    case $command in
        init)
            ziro_init "$@"
            ;;
        req|plan|step)
            ziro_$command "$@"
            ;;
        ralph)
            ziro_ralph "$@"
            ;;
        go)
            ziro_go "$@"
            ;;
        status)
            ziro_status "$@"
            ;;
        ls)
            ziro_list
            ;;
        help)
            ziro_help
            ;;
        *)
            ziro_help
            ;;
    esac
}

# Help text
ziro_help() {
    cat <<'EOF'
Ziro - Zero-Friction Spec-Driven Development

USAGE:
    ziro <command> [options]

COMMANDS:
    init [template]                Initialize ziro in current repo (zero-config)

    req [name] [--force]           Gather/refine requirements (transparently creates or continues)
    plan [name] [--force]          Architectural design phase (requires approved requirements)
    step [name] [--force]          Generate implementation tasks (requires approved design)

    ralph start|stop [name]        Start/stop the implementation loop (The Wiggum Loop)
    go [name]                      Resume implementation from last incomplete task
    status [name]                  Show current progress of the Ralph loop

    ls                             List all feature specs and their current status
    help                           Show this message

EXAMPLES:
    ziro init front-end
    ziro req tower-search              # Gather or refine requirements
    ziro plan tower-search             # Create or refine architectural design
    ziro step tower-search             # Generate or refine implementation tasks
    ziro req tower-search --force      # Override approval to refine requirements
    ziro ralph start tower-search      # "I'm helping!" - Start The Wiggum Loop
    ziro go tower-search               # Resume from last incomplete task
    ziro status tower-search           # Check implementation progress
    ziro ls                            # List all features and status

For more info: https://github.com/shakalabs/ziro
EOF
}

# Export for subcommands
export ZIRO_PLUGIN_DIR
export ZIRO_REPO_DIR
