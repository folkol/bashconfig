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

PATH="/Users/folkol/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/folkol/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/folkol/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/folkol/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/folkol/perl5"; export PERL_MM_OPT;

# added by travis gem
[ -f /Users/folkol/.travis/travis.sh ] && source /Users/folkol/.travis/travis.sh

# Created by `userpath` on 2020-08-07 19:24:13
export PATH="$PATH:/Users/folkol/.local/bin"
# pyenv
#eval "$(pyenv init -)"

# pyenv-virtualenv:
#eval "$(pyenv virtualenv-init -)"
function updatePrompt {

    # Styles
    GREEN='\[\e[0;32m\]'
    BLUE='\[\e[0;34m\]'
    RESET='\[\e[0m\]'

    # Base prompt: \W = working dir
    PROMPT="\W"

    # Current Git repo
    if type "__git_ps1" > /dev/null 2>&1; then
        PROMPT="$PROMPT$(__git_ps1 "${GREEN}(%s)${RESET}")"
    fi

    # Current virtualenv
    if [[ $VIRTUAL_ENV != "" ]]; then
        # Strip out the path and just leave the env name
        PROMPT="$PROMPT${BLUE}{${VIRTUAL_ENV##*/}}${RESET}"
    fi

    PS1="$PROMPT\$ "
}
export -f updatePrompt

# Bash shell executes this function just before displaying the PS1 variable
export PROMPT_COMMAND='updatePrompt'
#source "$HOME/.cargo/env"
##. "$HOME/.cargo/env"
