# If not running interactively, don't do anything
[ -z "$PS1" ] && return

PS1user="\\u\\[\\e[0m\\]"
PS1error='$( ret=$? ; test ${ret} -gt 0 && echo "\[\e[41;93m\][${ret}]\[\e[0m\]" )'
PS1="${PS1error}\t \\[\\e[01;32m\\]${PS1user}\\[\\e[01;32m\\]@\\h\\[\\e[01;34m\\] \\w\\$\\[\\e[00m\\] "
export PS1

for entry in ${HOME}/{.exports,.aliases,.functions,.friedman.local}; do
  [ -r ${entry} ] && source ${entry}
done

# Hishtory Config:
if [[ -x ${HOME}/.hishtory/hishtory ]]; then
  export PATH="$PATH:${HOME}/.hishtory"
  source ${HOME}/.hishtory/config.sh
fi
