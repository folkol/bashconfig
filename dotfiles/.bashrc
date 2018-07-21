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


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/folkol/node_modules/tabtab/.completions/serverless.bash ] && . /Users/folkol/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/folkol/node_modules/tabtab/.completions/sls.bash ] && . /Users/folkol/node_modules/tabtab/.completions/sls.bash

[ -s "/Users/folkol/.rvm/scripts/rvm" ] && source $HOME/.rvm/scripts/rvm
[ -s "/Users/folkol/.scm_breeze/scm_breeze.sh" ] && source "/Users/folkol/.scm_breeze/scm_breeze.sh"
