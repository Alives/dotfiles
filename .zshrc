autoload -U colors compinit promptinit select-word-style
colors
compinit
promptinit
select-word-style whitespace
zstyle ':completion:*:sudo:*' menu select
setopt completealiases

setopt appendhistory autocd nomatch prompt_subst
bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^H" backward-delete-word
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey '^i' expand-or-complete-prefix

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
PROMPT="${p_return}${p_time} ${p_user}${p_host} ${p_pwd}
${p_prompt} "

for entry in ${HOME}/{scripts/z/z.sh,.exports,.aliases,.functions,.friedman.local}; do
  [[ -r ${entry} ]] && source ${entry}
done
