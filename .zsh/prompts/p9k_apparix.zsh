# define an apparix segment for use with powerlevel9(10)k
# not currently used
if [[ "$GOEDEL_APPARIX" == "true" ]]; then
    function p9k_apparix_prompt {
        iz_bm="$(amibm)"
        if [[ -n "$iz_bm" ]]; then
            printf "%s" "$iz_bm"
        fi
    }
    POWERLEVEL9K_CUSTOM_APPARIX="p9k_apparix_prompt"
    POWERLEVEL9K_CUSTOM_APPARIX_BACKGROUND=cyan

    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS+=custom_apparix
fi
