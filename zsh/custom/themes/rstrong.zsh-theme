local host=MBP
local ret_status="%(?:%{$fg[blue]%}:%{$fg[red]%}%s)»%{$reset_color%}"

function precmd() {
    dockermachine_host=${DOCKER_HOST#"tcp://"}
    dockermachine_host=${dockermachine_host%":2376"}
    if [ "$dockermachine_host" != "" ]; then
        docker_machine=" %{$fg[blue]%}machine:(%{$fg[red]%}$dockermachine_host%{$fg[blue]%})%{$reset_color%}" 
    fi

    aws_env=$AWS_ROLE
    if [ "$aws_env" != "" ]; then
        aws_env="%{$fg[green]%}AWS[$aws_env]%{$reset_color%} "
    fi
}

PROMPT='%{$fg[green]%}%p${aws_env}%{$fg[cyan]%}%c$docker_machine%{$fg[blue]%} %{$fg[blue]%}$(git_prompt_info)%{$fg[blue]%}%{$ret_status%}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}✗%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) "
