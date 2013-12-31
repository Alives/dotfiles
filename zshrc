autoload -U colors compinit promptinit select-word-style
colors
compinit
promptinit
select-word-style whitespace

autoload -Uz vcs_info

#use extended color pallete if available
if [ ! -z $terminfo[colors] ] && [ $terminfo[colors] -eq 256 ] ; then
  yellow="$fg_bold[yellow]"
  gold="$fg[yellow]"
  red="$fg_bold[red]"
  black="$fg[black]"
  darkgrey="$fg_bold[black]"
  lightgrey="$fg[white]"
  white="$fg_bold[white]"
  turquoise="%F{81}"
  orange="%F{166}"
  purple="%F{135}"
  hotpink="%F{161}"
  limegreen="%F{118}"
else
  yellow="$fg_bold[yellow]"
  gold="$fg[yellow]"
  red="$fg_bold[red]"
  black="$fg[black]"
  darkgrey="$fg_bold[black]"
  lightgrey="$fg[white]"
  white="$fg_bold[white]"
  turquoise="$fg[cyan]"
  orange="$fg[yellow]"
  purple="$fg[magenta]"
  hotpink="$fg[red]"
  limegreen="$fg[green]"
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
FMT_PREFIX="${PR_RST}%{$fg[green]%}[${PR_RST}"
FMT_SUFFIX="${PR_RST}%{$fg[green]%}]${PR_RST}"
FMT_BRANCH="(%{$purple%}%b%u%c${PR_RST})"
FMT_ACTION="(%{$limegreen%}%a${PR_RST})"
FMT_UNSTAGED="%{$yellow%}●"
FMT_STAGED="%{$limegreen%}●"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

zstyle ':completion:*:sudo:*' menu select
setopt completealiases

function dis_preexec {
  case "$(history $HISTCMD | tail -n5)" in
    *git*)
      PR_GIT_UPDATE=1
      ;;
    *svn*)
      PR_GIT_UPDATE=1
      ;;
  esac
}
add-zsh-hook preexec dis_preexec

function dis_chpwd {
  PR_GIT_UPDATE=1
}

add-zsh-hook chpwd dis_chpwd

function dis_precmd {
  if [ -n "$PR_GIT_UPDATE" ] ; then
    # check for untracked files or updated submodules, since vcs_info doesn't
    if [ ! -z "$(git ls-files --other --exclude-standard 2> /dev/null)" ]; then
      PR_GIT_UPDATE=1
      FMT_BRANCH="${FMT_PREFIX}%{$purple%}%b%u%c%{$hotpink%}●${FMT_SUFFIX}"
    else
      FMT_BRANCH="${FMT_PREFIX}%{$purple%}%b%u%c${FMT_SUFFIX}"
    fi
    zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
    vcs_info 'prompt'
    PR_GIT_UPDATE=
  fi
}
add-zsh-hook precmd dis_precmd

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

# Prompt shit
local r="%{%b%f%}"
local p_return="%(?..%{$bg[red]$fg_bold[yellow]%}[%?]${r} )"
local p_time="%{$fg[white]%}%*${r}"
local p_user="%{$fg_bold[green]%}%n${r}"
local p_host="%{$fg[white]%}@%{$fg_bold[cyan]%}%m${r}"
local p_pwd="%{$fg_bold[blue]%}%~${r}"
local p_prompt="%{$fg_bold[yellow]%}%#${r}"
PROMPT='${p_return}${p_time} ${p_user}${p_host} ${p_pwd} $vcs_info_msg_0_
${p_prompt} '

for entry in ${HOME}/{.exports,.aliases,.functions,.friedman.local}; do
  [[ -r ${entry} ]] && source ${entry}
done
