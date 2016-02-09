autoload -U colors compinit promptinit select-word-style
colors
compinit
promptinit
select-word-style whitespace

autoload -Uz vcs_info

#use extended color pallete if available
if [ ! -z $terminfo[colors] ] && [ $terminfo[colors] -eq 256 ] ; then
  yellow="$fg_bold[yellow]"
  gold="%F{184}"
  lightblue="%F{33}"
  red="$fg[red]"
  green="$fg[green]"
  black="$fg[black]"
  darkgrey="$fg_bold[black]"
  lightgrey="$fg[white]"
  white="$fg_bold[white]"
  turquoise="%F{81}"
  orange="%F{208}"
  purple="%F{91}"
  hotpink="%F{206}"
  limegreen="%F{118}"
  c_time="%F{125}"
  c_user="%F{202}"
  c_at="%F{184}"
  c_host="%F{33}"
  c_pwd="%F{30}"
  c_presuf="%F{32}"
  c_branch="%F{148}"
  c_prompt="%F{196}"
else
  yellow="$fg_bold[yellow]"
  gold="$fg[yellow]"
  lightblue="$fg_bold[blue]"
  red="$fg[red]"
  green="$fg[green]"
  black="$fg[black]"
  darkgrey="$fg_bold[black]"
  lightgrey="$fg[white]"
  white="$fg_bold[white]"
  turquoise="$fg[cyan]"
  orange="$fg[yellow]"
  purple="$fg[magenta]"
  hotpink="$fg[red]"
  limegreen="$fg[green]"
  c_time="$fg[white]"
  c_user="$fg_bold[green]"
  c_at="$fg[white]"
  c_host="$fg_bold[cyan]"
  c_pwd="$fg_bold[blue]"
  c_presuf="$fg_bold[blue]"
  c_branch="$fg[yellow]"
  c_prompt="$fg_bold[yellow]"
fi

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%{${reset_color}%}"
FMT_PREFIX="${PR_RST}%{$c_presuf%}[${PR_RST}"
FMT_SUFFIX="${PR_RST}%{$c_presuf%}]${PR_RST}"
FMT_BRANCH="(%{$c_branch%}%b%u%c${PR_RST})"
FMT_ACTION="(%{$red%}%a${PR_RST})"
FMT_UNSTAGED="%{$yellow%}●${PR_RST}"
FMT_STAGED="%{$green%}●${PR_RST}"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

zstyle ':completion:*:sudo:*' menu select
setopt completealiases

function git_precmd {
  # check for untracked files or updated submodules, since vcs_info doesn't
  if [ ! -z "$(git ls-files --other --exclude-standard 2> /dev/null)" ]; then
    FMT_BRANCH="${FMT_PREFIX}%{$c_branch%}%b%{$fg[red]%}●%u%c${FMT_SUFFIX}"
  else
    FMT_BRANCH="${FMT_PREFIX}%{$c_branch%}%b%u%c${FMT_SUFFIX}"
  fi
  zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH}"
  vcs_info 'prompt'
}
add-zsh-hook precmd git_precmd

setopt appendhistory autocd nomatch prompt_subst
bindkey -v
bindkey '^R'     history-incremental-search-backward
bindkey "^K"     kill-line
bindkey "^E"     end-of-line
bindkey "^[[A"   history-search-backward
bindkey "^[[B"   history-search-forward
bindkey "^[[5~"  up-line-or-history
bindkey "^[[6~"  down-line-or-history
bindkey "\e[1~"  beginning-of-line
bindkey "\e[4~"  end-of-line
bindkey "\e[5~"  beginning-of-history
bindkey "\e[6~"  end-of-history
bindkey "\e[3~"  delete-char
bindkey "\e[2~"  quoted-insert
bindkey "\e[5C"  forward-word
bindkey "\eOc"   emacs-forward-word
bindkey "\e[5D"  backward-word
bindkey "\eOd"   emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^H"     backward-delete-word
bindkey "\e[8~"  end-of-line
bindkey "\e[7~"  beginning-of-line
bindkey "\eOH"   beginning-of-line
bindkey "\eOF"   end-of-line
bindkey "\e[H"   beginning-of-line
bindkey "\e[F"   end-of-line
bindkey '^i'     expand-or-complete-prefix

HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000

## Prompt shit
#local r="%{%b%f%}"
#local p_return="%(?..%{$bg[red]$fg_bold[yellow]%}[%?]${r} )"
#local p_time="%{$fg[white]%}%*${r}"
#local p_user="%{$fg_bold[green]%}%n${r}"
#local p_host="%{$fg[white]%}@%{$fg_bold[cyan]%}%m${r}"
#local p_pwd="%{$fg_bold[blue]%}%~${r}"
#local p_prompt="%{$fg_bold[yellow]%}%#${r}"
#PROMPT='${p_return}${p_time} ${p_user}${p_host} ${p_pwd} $vcs_info_msg_0_
#${p_prompt} '

# Prompt shit
test -r ${HOME}/.prompt && source ${HOME}/.prompt
local r="%{%b%f%}"
local p_return="%(?..%{$bg[red]$fg_bold[yellow]%}[%?]${r} )"
local p_time="%{$c_time%}%*${r}"
local p_user="%{$c_user%}%n${r}"
local p_host="%{$c_at%}@%{$c_host%}%m${r}"
local p_pwd="%{$c_pwd%}%~${r}"
local p_prompt="%{$c_prompt%}%#${r}"
PROMPT='${p_return}${p_time} ${p_user}${p_host} ${p_pwd} $vcs_info_msg_0_
${p_prompt} '

for entry in ${HOME}/{.dotfiles/{exports,aliases,functions,scripts/z/z.sh},.zsh.local}; do
  test -r ${entry} && source ${entry}
done
