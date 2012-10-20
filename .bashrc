PS1user="\\u\\[\\e[0m\\]"
PS1error='$( ret=$? ; test ${ret} -gt 0 && echo "\[\e[41;93m\][${ret}]\[\e[0m\]" )'
PS1="${PS1error}\t \\[\\e[01;32m\\]${PS1user}\\[\\e[01;32m\\]@\\h\\[\\e[01;34m\\] \\w\\$\\[\\e[00m\\] "
export PS1

test -f /usr/bin/dircolors && eval $(/usr/bin/dircolors -b)

for entry in ${HOME}/{.aliases,.functions,.exports,/scripts/z.sh}; do
  test -f ${entry} && source ${entry}
done
