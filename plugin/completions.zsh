#!/usr/bin/env zsh
# Zsh completion for ziro command

# Get list of available features
_ziro_get_features() {
    if [[ -d .ziro/specs ]]; then
        ls -1 .ziro/specs 2>/dev/null | grep -v "^\.gitkeep$"
    fi
}

# Get list of available templates (dynamically discover from plugin)
_ziro_get_templates() {
    if [[ -n "$ZIRO_REPO_DIR" && -d "$ZIRO_REPO_DIR/.ziro/templates" ]]; then
        for template_dir in "$ZIRO_REPO_DIR"/.ziro/templates/*-templates; do
            if [[ -d "$template_dir" ]]; then
                local template_name="${template_dir##*/}"
                echo "${template_name%-templates}"
            fi
        done
    fi
}

# Main completion function (handles both zsh and bash)
_ziro_completion() {
    local cur prev words cword

    if [[ -n ${ZSH_VERSION-} ]]; then
        # In zsh with compctl -K, the function receives arguments and has access to:
        # $words - array of words on command line (1-indexed in zsh)
        # $CURRENT - index of current word being completed (1-indexed)
        cur="${words[$CURRENT]}"
        prev="${words[$((CURRENT - 1))]}"
        cword=$((CURRENT - 1))
    else
        # In bash, use standard bash completion variables
        cur="${COMP_WORDS[$COMP_CWORD]}"
        prev="${COMP_WORDS[$((COMP_CWORD - 1))]}"
        words=("${COMP_WORDS[@]}")
        cword=$COMP_CWORD
    fi

    # Get the first subcommand (index 1 since 0 is 'ziro')
    local cmd="${words[1]}"

    # Complete based on command
    case $cmd in
        init)
            _ziro_compreply "$(_ziro_get_templates)" "$cur"
            ;;
        req|plan|step)
            # For req/plan/step, complete with feature names and --force flag
            _ziro_compreply "$(_ziro_get_features) --force" "$cur"
            ;;
        ralph)
            case "${words[2]}" in
                start|stop)
                    _ziro_compreply "$(_ziro_get_features)" "$cur"
                    ;;
                *)
                    _ziro_compreply "start stop" "$cur"
                    ;;
            esac
            ;;
        go|status)
            _ziro_compreply "$(_ziro_get_features)" "$cur"
            ;;
        *)
            _ziro_compreply "init req plan step ralph go status ls help" "$cur"
            ;;
    esac
}

# Helper function to add completion results (zsh or bash compatible)
_ziro_compreply() {
    local options="$1"
    local cur="$2"

    if [[ -n ${ZSH_VERSION-} ]]; then
        # For zsh, output words matching the prefix
        for option in $options; do
            [[ "$option" == "$cur"* ]] && compadd "$option"
        done
    else
        # For bash, set COMPREPLY array using compgen
        COMPREPLY=($(compgen -W "$options" -- "$cur"))
    fi
}

# Register completion for zsh
if [[ -n ${ZSH_VERSION-} ]]; then
    # For zsh, we use a simpler approach with compctl
    compctl -K _ziro_completion ziro
elif [[ -n ${BASH_VERSION-} ]]; then
    # For bash
    complete -o bashdefault -o default -o nospace -F _ziro_completion ziro
fi
