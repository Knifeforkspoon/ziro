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
        req)
            ziro_req "$@"
            ;;
        plan)
            ziro_plan "$@"
            ;;
        step)
            ziro_step "$@"
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
    init [template]      Initialize ziro in current repo (zero-config)

    req [create|edit]    Gather/Refine requirements (Zero ambiguity)
    plan [create|edit]   Architectural design phase (The Kiro path)
    step [create|edit]   Generate implementation tasks (Zero wasted effort)

    ralph [start|stop]   Start/Stop the implementation loop (The Wiggum Loop)
    go [name]            Resume implementation from last incomplete task
    status [name]        Show current progress of the Ralph loop

    ls                   List all feature specs and their current status
    help                 Show this message

EXAMPLES:
    ziro init front-end
    ziro req create tower-search    # Claude guides requirements gathering
    ziro plan create tower-search   # Generates technical design
    ziro step create tower-search   # Breaks design into actionable tasks
    ziro ralph start tower-search   # "I'm helping!" - Starts implementation
    ziro go tower-search            # Resumes the loop

For more info: https://github.com/shakalabs/ziro
EOF
}

# Export for subcommands
export ZIRO_PLUGIN_DIR
export ZIRO_REPO_DIR
