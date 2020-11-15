##################### ZSH  ####################
#------------------------------------------------#
# alias tmux="env TERM=screen-256color tmux"
# alias tmux="env TERM=myterm-it tmux"





##################### DEFAULTS ####################
#-------------------------------------------------#
export KEYTIMEOUT=1
export PAGER="less"



##################### Utilities ####################
#--------------------------------------------------#
function s() {
  if [ -z "$2" ]; then
    grep -rn ./ -e "$1"
  else
    grep -rn $1 -e "$2"
  fi
}

function pushall() {
  branch=$(git branch --show-current)
  git add .
  git commit -a -m "update $(date +"%dth %B, %Y")"
  git push origin $branch
}

##################### FZF  ####################
#------------------------------------------------#
bindkey -v '^?' backward-delete-char
bindkey -v '^r' fzf-history-widget
bindkey -v '^f' fzf-cd-widget





##################### BAT ########################
#------------------------------------------------#
export BAT_PAGER="less -R"
export BAT_THEME="zenburn"






##################### File manager ####################
#-----------------------------------------------------#
export NNN_PLUG='v:-_bat $nnn*;e:fzopen;o:fzcd;'
export NNN_COLORS="6213"  # use a different color for each context
export NNN_BMS='d:~/Downloads/;c:~/myconfig/'
alias n="nn -eH"
function nn () {
  # Block nesting of nnn in subshells
  if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

  # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
  # To cd on quit only on ^G, remove the "export" as in:
  #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
  # NOTE: NNN_TMPFILE is fixed, should not be modified
  export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  nnn "$@"

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}


##################### Display ####################
#------------------------------------------------#
# Display DP to either left or right
# USAGE: dmonitor right
function dmonitor() {
  xrandr --output DP1 --auto --$1-of eDP1
}

# Display HDMI2 to either left or right
# USAGE: hmonitor right
function hmonitor() {
  xrandr --output HDMI2 --auto --$1-of eDP1
}




##################### GIT ####################
#--------------------------------------------#
function to-be-pushed() {
    branch=$(git branch | grep \* | cut -d ' ' -f2)
    git diff --stat --cached origin/$branch
}

function git-to-push() {
    branch=$(git branch | grep \* | cut -d ' ' -f2)
    git log origin/$branch...$branch
}

eval "$(starship init zsh)"
