export PATH=/home/$USER/bin:$PATH

# Customize to your needs...
local fb_prompt_file="${LOCAL_ADMIN_SCRIPTS}/scm-prompt"
if [ -f "$fb_prompt_file" ]; then
source "$fb_prompt_file"
else
echo "couldn't find FB SCM prompt file ${fb_prompt_file}"
fi
setopt interactivecomments
set -o vi
stty stop undef

alias vi='nvr'
alias cp='cp --backup=numbered'
alias ln='ln --backup=numbered'
alias mv='mv -f --backup=numbered'
HISTSIZE=130000 HISTFILESIZE=-1

bindkey '^R' history-incremental-search-backward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

export no_proxy=".fbcdn.net,.facebook.com,.thefacebook.com,.tfbnw.net,.fb.com,.fburl.com,.facebook.net,.sb.fbsbx.com,localhost"
# export http_proxy=fwdproxy:8080
# export https_proxy=fwdproxy:8080

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias my='myles'
alias myl='myles --im-feeling-lucky'

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && vi "${files[@]}"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# vf - fuzzy open with vim from anywhere
# ex: vf word1 word2 ... (even part of a file name)
# zsh autoload function
vf() {
  local files

  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

  if [[ -n $files ]]
  then
     vi -- $files
     print -l $files[1]
  fi
}
# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
  }

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'

msd() { bash -c "source ~/mysql/tools/mysqldebugging.sh && $*" }
dl() { bash -c "source /usr/facebook/scripts/db/dba_lib.sh && $*" }

source ~/mysql/tools/mysqldebugging.sh

export PYENV_ROOT="/usr/local/bin/pyenv"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
