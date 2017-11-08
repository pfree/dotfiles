IGNOREEOF=10   # Shell only exists after the 10th consecutive Ctrl-d

## Start SSH  agent
#SSH_ENV="$HOME/.ssh/environment"
#function start_agent {
#     echo "Initialising new SSH agent..."
#     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#     echo succeeded
#     chmod 600 "${SSH_ENV}"
#     . "${SSH_ENV}" > /dev/null
#     /usr/bin/ssh-add;
#}
#
## Source SSH settings, if applicable
#if [ -f "${SSH_ENV}" ]; then
#     . "${SSH_ENV}" > /dev/null
#     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#         start_agent;
#     }
#else
#     start_agent;
#fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
      xterm-color) color_prompt=yes;;
esac

# customize prompt
# ☞
# symbol="☞ "
# symbol="▶"
symbol="❯❯❯"
symbol1="❯"
symbol2="❯"
symbol3="❯"
hostcolor='\[\033[00;36m\]'

function parse_git_dirty { # show * next to branch name if unclean
  [[ $(git status 2> /dev/null | tail -n1) =~ "clean" ]] || echo "*"
}
function parse_git_branch { # show current branch name
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}
function git_stash_size { # show # of stashes for current repo
  lines=$(git stash list -n 100 2> /dev/null) || return
  if [ "${#lines}" -gt 0 ]
  then
    count=$(echo "$lines" | wc -l | sed 's/^[ \t]*//') # strip tabs
    echo ""⚑${count#}""
  fi
}
function pre_cmd { # alert if command finishes
   echo -n -e "\a"
  history -a
  history -r
}

# git heavy - 2 line prompt
PROMPT_DIRTRIM=8
export PS1="$(pre_cmd)\u@${hostcolor}\h:\[\033[35m\]\w\[\033[00m\]\[\033[33m\]\$(parse_git_branch)\[\033[31m\] \$(git_stash_size)\[\033[00m\]\n\[\033[34m\]└─\\[\033[1;32m\]$symbol1\[\033[00m\]\[\033[1;33m\]$symbol2\[\033[00m\]\[\033[1;31m\]$symbol3\[\033[00m\] "

# Source other config files
if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
fi
if [ -f ~/.bash_functions ]; then
      . ~/.bash_functions
fi
if [ -f ~/.dircolors ]; then
      . ~/.dircolors
fi
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Better history format
export HISTFILESIZE=
export HISTSIZE=
HISTTIMEFORMAT="%d/%m/%y %T "
HISTCONTROL=ignoreboth
HISTCONTROL=ignoredups
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Functions
# naming format: <function_name> () { ### <comment here>
showfun () { ### print list of functions in .bashrc
  grep "###" ~/.bashrc | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /:/' | awk -F: '{printf "\033[34m%-15s \033[00m%-40s\n", $1, $2 }' | grep -v -e "grep" -e "comment"
}
tmw () { ### send command after function to new tmux pane
  tmux split-window -dh "$*"
}
vfile () { ### find file matching input and open in vim
  vim "$(find -type f -name $1 | head -n 2 | tail -n 1 | awk '{print $NF}')"
}
tnew () { ### create new tmux session
  tmux new -s $1 -d
  tmux rename-window -t $1 ''
  tat $1
}
row2list () { ### file containing row to list
cat $1 | tr -s ' ' '\n'
}
list2csv () { ### file containing list 2 csv
  cat $1 | xargs | sed -e 's/ /,/g'
}
list2row () { ### file containing list 2 row
  cat $1 | xargs | sed -e 's/ / /g'
}
showrepos () { ### show checked out  branches
  for d in ~/projects/*/; do
    printf "$d" | cut -d/ -f5 | tr -d '\n'
    cd $d
    echo -e "\033[32m$(parse_git_branch) \033[31m$(git_stash_size)\033[0m"
    cd ..
  done | column -t
  cd
}
showvimrepos () { ### show vim plugins
  for d in ~/.vim/bundle/*/; do
    printf "$d" | cut -d/ -f5 | tr -d '\n'
    cd $d && git status | grep "On branch" | awk '{print "\033[34m" " ("$3")" "\033[0m";}' && cd ..
  done | column -t
  cd
}
updatevimrepos () { ### update vim repos
  for d in ~/.vim/bundle/*/; do
    cd $d
    echo $d | rev | cut -d/ -f2 | rev | xargs printf "\033[32m%s\033[0m\n"
    git pull --rebase && cd ..
  done
  cd
}
updatetmuxrepos () { ### update tmux repos
  for d in ~/.tmux/plugins/*/; do
    cd $d
    echo $d | rev | cut -d/ -f2 | rev | xargs printf "\033[32m%s\033[0m\n"
    git pull --rebase && cd ..
  done
  cd
}
cleanrepos () { ### Run git clean on project, vim & tmux repos
  for d in ~/projects/*/; do
    echo $d | rev | cut -d/ -f2 | rev | xargs printf "\033[32m%s\033[0m\n"
    cd $d && git gc && cd ..
  done
  for d in ~/.vim/bundle/*/; do
    echo $d | rev | cut -d/ -f2 | rev | xargs printf "\033[32m%s\033[0m\n"
    cd $d && git gc && cd ..
  done
  for d in ~/.tmux/plugins/*/; do
    echo $d | rev | cut -d/ -f2 | rev | xargs printf "\033[32m%s\033[0m\n"
    cd $d && git gc && cd ..
  done
  cd
}
tls () { ### Display tmux sessions
  COL1="$(tmux ls | cut -d: -f1 | grep 'release')"
  COL2="$(tmux ls | cut -d: -f1 | grep -v '[0-9]' | grep -v 'release')"
  COL3="$(tmux ls | cut -d: -f1 | grep '[0-9]')"
  YELLOW='\033[1;33m'
  MAGENTA='\033[35m'
  NC='\033[0m'
  COMB="$(pr -t -m <(echo "$COL1") <(echo "$COL2") <(echo "$COL3"))"
  echo -e "${MAGENTA}$COMB ${NC}"
}
manp () { ### show colored manpage
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;35m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[4;36m") \
    man $@
}
#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
extract () { ### Autodetect and extract arg $1
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
colors () { ### Show terminal colors & codes
  T='gYw'   # The test text

  echo -e "\n                 40m     41m     42m     43m\
       44m     45m     46m     47m";

  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
             '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
             '  36m' '1;36m' '  37m' '1;37m';
    do FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
      do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
    done
    echo;
  done
  echo
}
plscolors () { ### For LS_COLORS, print color, type, and, if available, description.
  IFS=:
  for ls_color in $LS_COLORS; do
    color=${ls_color#*=}
    type=${ls_color%=*}

    case "$type" in
      bd) type+=" (block device)" ;;
      ca) type+=" (file with capability)" ;;
      cd) type+=" (character device)" ;;
      di) type+=" (directory)" ;;
      do) type+=" (door)" ;;
      ex) type+=" (executable)" ;;
      ln) type+=" (symbolic link)" ;;
      mh) type+=" (multi-hardlink)" ;;
      mi) type+=" (missing file)" ;;
      no) type+=" (global default)" ;;
      or) type+=" (orphan symlink)" ;;
      ow) type+=" (other writable)" ;;
      pi) type+=" (named pipe)" ;;
      rs) type+=" (reset to normal color)" ;;
      sg) type+=" (set gid)" ;;
      so) type+=" (socket)" ;;
      st) type+=" (sticky)" ;;
      su) type+=" (set uid)" ;;
      tw) type+=" (sticky other writable)" ;;
      *)  ;;
    esac

    printf "\033[%sm%s\033[m " "$color" "$type"
  done
  echo
}
