#!/usr/bin/env zsh
# Shakapawd - Spec-Driven Development System Plugin for Oh-My-Zsh
# Facilitates: init, feature, design, tasks, build

# Get plugin directory
SHAKAPAWD_PLUGIN_DIR="${0:h}"
SHAKAPAWD_REPO_DIR="${SHAKAPAWD_PLUGIN_DIR}/../"

# Source all command functions
for cmd_file in "$SHAKAPAWD_PLUGIN_DIR"/commands/*.zsh; do
    source "$cmd_file"
done

# Main shakapawd dispatcher
shakapawd() {
    local command=$1
    shift

    case $command in
        init)
            shakapawd_init "$@"
            ;;
        feature)
            shakapawd_feature "$@"
            ;;
        design)
            shakapawd_design "$@"
            ;;
        tasks)
            shakapawd_tasks "$@"
            ;;
        build)
            shakapawd_build "$@"
            ;;
        list)
            shakapawd_list
            ;;
        help)
            shakapawd_help
            ;;
        *)
            shakapawd_help
            ;;
    esac
}

# Help text
shakapawd_help() {
    cat <<'EOF'
Shakapawd - Spec-Driven Development System

USAGE:
    shakapawd <command> [options]

COMMANDS:
    init [template]              Initialize shakapawd in current repo
                                 template: front-end, back-end (prompts if not specified)

    feature create [name]        Create new feature spec
    feature edit [name]          Edit feature (opens selector)
    feature delete [name]        Delete feature spec

    design [name]                Edit design.md for feature
    design edit [name]           Same as above

    tasks [name]                 Edit tasks.md for feature
    tasks edit [name]            Same as above

    build start [name]           Start implementation from task 1.1
    build resume [name]          Resume from last incomplete task
    build stop [name]            Stop/pause current build
    build status [name]          Show build progress

    list                         List all feature specs with status
    help                         Show this help message

EXAMPLES:
    shakapawd init                           # Prompts to choose template
    shakapawd init front-end                 # Initialize with front-end templates
    shakapawd feature create tower-search    # Create feature spec
    shakapawd design tower-search            # Edit design.md
    shakapawd tasks tower-search             # Edit tasks.md
    shakapawd build start tower-search       # Start implementation
    shakapawd build resume tower-search      # Resume implementation
    shakapawd list                           # Show all features

For more info: https://github.com/shakalabs/shakapawd
EOF
}

# Export for subcommands
export SHAKAPAWD_PLUGIN_DIR
export SHAKAPAWD_REPO_DIR
