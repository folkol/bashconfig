GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_END="\n★ "
[ -f /usr/local/share/gitprompt.sh ] && . /usr/local/share/gitprompt.sh
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#echo "Now executing ~/.bashrc"
#
#export PATH="/opt/local/bin:$PATH"
#
#### IMPORTS
#source ~/bin/git-completion.bash
#
##export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home
#
#
#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

[ -s "/Users/folkol/.scm_breeze/scm_breeze.sh" ] && source "/Users/folkol/.scm_breeze/scm_breeze.sh"
