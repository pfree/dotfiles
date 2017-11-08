# convenience
alias u='. ~/.bash_profile'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias ls='ls -Gp'
alias lh='ls -FGlAh'
alias ll='ls -FGlA'
alias ldir='ls --indicator-style=none -d */'
alias less='less -R'
alias vcat='vimcat'
alias showa='vcat ~/.bash_aliases'
alias psgrep='ps aux | head -1 && ps aux | grep'
alias bnice='nice -n19 ionice -c 3'

# quick edit dotfiles
alias vvrc='vim ~/.vimrc'
alias vbrc='vim ~/.bashrc'
alias vtc='vim ~/.tmux.conf'
alias vba='vim ~/.bash_aliases'
alias vgc='vim ~/.gitconfig'

# git
alias gst='git status'
alias gsl='git stash list -p'

# find commands
alias f='grep -nir'
alias ffile='find . -type f -name'
alias fdir='find . -type d -name'

# tmux
alias tmux='tmux -2'
alias tu='tmux source-file ~/.tmux.conf'
alias tat='tmux a -t'
alias tkill='tmux kill-session -t'

# housekeeping
alias delswp='find -type f -name *.*.swp | xargs rm'
alias delview='rm -r ~/.vim/view'

# misc
alias topcommands="history | awk '{CMD[\$4]++;count++;}END { for (a in CMD)print CMD[a] \" \" CMD[a]/count*100 \"% \" a;}' | grep -v \"./\" | column -c3 -s \" \" -t | sort -nr | nl |  head -n10"
alias weather="curl http://wttr.in/29412"
