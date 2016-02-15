local host=$(hostname)
local ret_status="%(?:%{$fg_bold[blue]%}$host:%{$fg_bold[red]%}$host%s):"

function precmd() {
    dockermachine_host=${DOCKER_HOST#"tcp://"}
    dockermachine_host=${dockermachine_host%":2376"}
    if [ "$dockermachine_host" != "" ]; then
        docker_machine=" %{$fg_bold[blue]%}machine:(%{$fg[red]%}$dockermachine_host%{$fg_bold[blue]%})%{$reset_color%}" 
    fi
}

PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c$docker_machine%{$fg_bold[blue]%} %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}✗%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) "
