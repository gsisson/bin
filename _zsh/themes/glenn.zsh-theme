# start with the Bureau theme
. $(dirname $0)/bureau.zsh-theme
bureau_precmd () {} #null out the hook function defined in bureau.zsh-theme

# my colors for Mac Terminal and iTerm2
autoload -U colors && colors
typeset -A fg2
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
  fg2[green]="$BG[040]"
  fg2[green_bg]="$BG[040]"
  fg2[limegreen]="%F{118}"
  fg2[blue]="$FG[033]"
  fg2[blue_bg]="$BG[033]"
  fg2[orange]="$FG[166]"
  fg2[orange_bg]="$BG[166]"
  fg2[turquoise]="$FG[081]"
  fg2[turquoise_bg]="$BG[081]"
  fg2[purple]="$FG[135]"
  fg2[purple_bg]="$BG[135]"
  fg2[hotpink]="$FG[161]"
  fg2[hotpink_bg]="$BG[161]"
else
  fg2[green]="$fg[green]"
  fg2[limegreen]="$fg[green]"
  fg2[blue]="$fg[blue]"
  fg2[orange]="$fg[yellow]"
  fg2[turquoise]="$fg[cyan]"
  fg2[purple]="$fg[magenta]"
  fg2[hotpink]="$fg[red]"
fi

# GIT PROMPT CHANGES

# same fucntion as in Bureau, but with a couple of mods

bureau_git_prompt () {
  local _branch=$(bureau_git_branch)
  local _status=$(bureau_git_status)
        _status=${_status:-$ZSH_THEME_GIT_PROMPT_CLEAN} # added to set the check mark if clean
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result$_status"                        # changed from bureau (removed space)
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}

# get rid of the plus/minus sign
  ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[green]%}%{$reset_color%}%{$fg_bold[white]%}"
# change git status colors - swap red and yellow dots (which seem backwards)
  # red color if the file is in the repo, but has changed
  ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●%{$reset_color%}"
  # cyan color if the file is not in the repo
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}●%{$reset_color%}"

# set the prompt my way

  if [[ $EUID -eq 0 ]]; then
    _color=$fg2[hotpink]
  else
    _color=$fg2[green_bg]
    _color=$fg2[orange_bg]
    _color=$fg2[purple_bg]
    _color=$fg2[purple_bg]
  fi

  _USER_HOST="%{$_color%}%n%{$reset_color%}@%{$_color%}%m:%{$reset_color%}"
  _USER_HOST="%{$_color%} $ %{$reset_color%}" # ▶▷

  _LIBERTY="🌜" # moon
  _LIBERTY="🍏 " # green apple + space
  _LIBERTY="" # nothing
  _PATH="%{$fg2[limegreen]%}%~%{$reset_color%}"

  PROMPT='${_USER_HOST}%{$bg[black]%}%{$fg[white]%}${_LIBERTY}%{$reset_color%}'
  RPROMPT='${_PATH}$(nvm_prompt_info)$(ruby_env)$(bureau_git_prompt)'
