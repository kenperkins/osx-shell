# Shell colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Fixup Path for textedit 
PATH=$PATH:/Applications/WebStorm.app/bin

function docker-context()
{
    if [ -z "$DOCKER_HOST" ]; then
      return
    else
      local HOSTNAME_REGEX=".*//(.*):.*"
      [[ $DOCKER_HOST =~ $HOSTNAME_REGEX ]]
      printf " d:${BASH_REMATCH[1]}"
    fi
}

function kubernetes-context()
{
    local KUBERNETES_CONTEXT=$(kubectl config current-context)
    local HAS_NAMESPACE=$(kubectl config view -o jsonpath='{.contexts[?(@.name == "'"$KUBERNETES_CONTEXT"'")].context.namespace}')
    local NAMESPACE=${HAS_NAMESPACE:-default}

    printf $KUBERNETES_CONTEXT[$NAMESPACE]
}

# setup autocompletion tools
complete -C '/usr/local/bin/aws_completer' aws
source /Users/ken/.rack/bash_autocomplete
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
source <(kubectl completion bash)

# git prompt
GIT_PS1_SHOWDIRTYSTATE=true

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# base prompt used for additional support
PS1='\[\e[01;37m\]\w\[\e[00;35m\]$(__git_ps1)\[\e[00m\] (k:$(kubernetes-context)$(docker-context "%s")) \$ '

# Prefix a newline in front of prompt
PS1="\n\[\e[G\]$PS1"

# set our working directory
cd ~/src
