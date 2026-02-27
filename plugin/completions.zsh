#!/usr/bin/env zsh
# Zsh completion for shakapawd command

# Get list of available features
_shakapawd_get_features() {
    if [[ -d .shakapawed/specs ]]; then
        ls -1 .shakapawed/specs 2>/dev/null | grep -v "^\.gitkeep$"
    fi
}

# Get list of available templates
_shakapawd_get_templates() {
    echo "front-end"
    echo "back-end"
}

# Main completion function
_shakapawd_completion() {
    local cur prev words cword
    cur="${COMP_WORDS[$((COMP_CWORD))]}"
    prev="${COMP_WORDS[$((COMP_CWORD - 1))]}"
    words=("${COMP_WORDS[@]}")
    cword=$COMP_CWORD

    # Get the command
    local cmd="${words[1]}"

    # Complete based on command
    case $cmd in
        init)
            # Complete templates
            COMPREPLY=($(compgen -W "$(_shakapawd_get_templates)" -- "$cur"))
            ;;
        feature)
            case "${words[2]}" in
                create|edit|delete)
                    # Complete with feature names
                    COMPREPLY=($(compgen -W "$(_shakapawd_get_features)" -- "$cur"))
                    ;;
                *)
                    # Complete with actions
                    COMPREPLY=($(compgen -W "create edit delete" -- "$cur"))
                    ;;
            esac
            ;;
        design|tasks)
            # Complete with feature names
            COMPREPLY=($(compgen -W "$(_shakapawd_get_features)" -- "$cur"))
            ;;
        build)
            case "${words[2]}" in
                start|resume|stop|status)
                    # Complete with feature names
                    COMPREPLY=($(compgen -W "$(_shakapawd_get_features)" -- "$cur"))
                    ;;
                *)
                    # Complete with actions
                    COMPREPLY=($(compgen -W "start resume stop status" -- "$cur"))
                    ;;
            esac
            ;;
        *)
            # Complete with main commands
            COMPREPLY=($(compgen -W "init feature design tasks build list help" -- "$cur"))
            ;;
    esac
}

# Register completion for zsh
if [[ -n ${ZSH_VERSION-} ]]; then
    # For zsh, we use a simpler approach with compctl
    compctl -K _shakapawd_completion shakapawd
elif [[ -n ${BASH_VERSION-} ]]; then
    # For bash
    complete -o bashdefault -o default -o nospace -F _shakapawd_completion shakapawd
fi
