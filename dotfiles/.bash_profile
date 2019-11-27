# Leave my ^S alone!
# if tty -s; then
stty stop undef
stty start undef
# fi

### HISTORY COMMANDS

shopt -s histappend
PROMPT_COMMAND="history -n; history -a; $PROMPT_COMMAND"
export HISTCONTROL=ignoreboth
export HISTFILESIZE=
export HISTSIZE=
export CLICOLOR=Hxxxbxxxxxx

### PATH

#export PATH=$(brew --prefix openssl)/bin:$PATH
export PATH="/usr/local/opt/openssl:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH=$PATH:/Users/folkol/bin/scripts:/Users/folkol/bin/polopoly:/Users/folkol/bin
export PATH=/usr/bin/wget:/usr/local/apache-maven/apache-maven-2.2.1/bin/mvn:/usr/local/sbin:$PATH
export PATH=$PATH:/Applications/JD-GUI.app/Contents/MacOS
export PATH=/usr/local/bin:$PATH
export PATH="/Users/folkol/code/ace/system-tests/test-scripts/bin:$PATH"
export PATH="$PATH:/Users/folkol/Library/Python/2.7/bin"
export PATH="$PATH:/Users/folkol/code/futils/bin"
export PATH="/usr/local/opt/flex/bin:$PATH"
export PATH="/usr/local/opt/texinfo/bin/:$PATH"
export PATH="/Users/folkol/code/futils/bin:$PATH"
export PATH="$(brew --prefix)/opt/python/libexec/bin:$PATH"
export PATH="/Users/folkol/bin:/Users/folkol/bin/scripts:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="$HOME/Library/Python/3.7/bin/:$PATH"
export PATH="$HOME/Library/Python/3.6/bin/:$PATH"
export PATH="$PATH:~/.tacit"

### IMPORTS
source ~/.bashrc ### EXPORTS
export PS1='\[\033[1;31m\]♥\[\033[0m\] '
PROMPT_COMMAND='BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)'
PS1='$BRANCH$ '
export MY_POLOPOLY_HOME=/Users/folkol/polopoly
export MY_POLOPOLY_DIST=$MY_POLOPOLY_HOME/dist
export MY_POLOPOLY_DIST_ROOT=$MY_POLOPOLY_DIST/dist-root
export AWK_COL_TO_PRINT=$1
export REBEL_HOME="/Users/folkol/jrebel/"
export MAVEN_OPTS="-Xmx1536m -Xms128m -XX:+HeapDumpOnOutOfMemoryError"
export ANT_OPTS=-Xmx1024m
export BC_LINE_LENGTH=200000000
export GROOVY_HOME=/usr/local/opt/groovy/libexec

#export DEBUG='-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address='
export VAULT_ADDR=https://vault.ivbar.com:8200

### FUNCTIONS

hnt() {
    head "$@"
    echo "..."
    tail "$@"
}

function get_era_ticket_initial() {
    if ! \git rev-parse --is-inside-work-tree &>/dev/null; then
        exit
    fi
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local ticket=$(echo $branch | grep -Eo '^era-[0-9]+')
    echo "gc -m '$ticket:"
}

function get_era_ticket() {
    if ! \git rev-parse --is-inside-work-tree &>/dev/null; then
        exit
    fi
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local ticket=$(echo $branch | grep -Eo '^era-[0-9]+')
    if [ -n "$ticket" ]; then
        ticket=" '$ticket:"
    fi
    echo "-m$ticket"
}

function launchctl-info() {
    if [ $# -eq 0 ]; then
        echo 'usage: launchctl-info *service-pattern*' >&2
        return 1
    fi
    local service_pattern=$1
    launchctl list \
        | awk "/$service_pattern/ { print \$3 }" \
        | while read -r daemon; do
            launchctl dumpstate | sed -n "/^$daemon /,/^}/p"
        done
}

function burl() {
    local HOST="$1"
    local PATH="$2"
    exec 3<>/dev/tcp/$HOST/80
    cat <<EOF >&3
GET $PATH HTTP/1.1
Host: $HOST

EOF
    cat <&3
}

function kube-get-pods-all-ns() {
    mapfile <<<$(kubectl get pods --all-namespaces | grep -v kube-system | tail -n +2)

    i=1
    for line in "${MAPFILE[@]}"; do
        read NAMESPACE NAME READY STATUS RESTARTS AGE <<<$(echo $line)
        declare -g e$((i++))="$NAME -n $NAMESPACE"
    done

    i=1
    for line in "${MAPFILE[@]}"; do
        echo [$((i++))] $line
    done | column -t
}

function kube-attach() {
    kubectl attach -it $1 $2 $3
}

function kube-exec() {
    kubectl exec -it $1 $2 $3 ${4:-bash}
}

function git-hot() {
    local i=1
    for ref in $(git for-each-ref --count=30 --sort=-committerdate refs/remotes/ --format='%(refname:short)'); do
        echo "  [$i] $ref"
        declare -g "e$((i++))=${ref#*/}"
    done
}

vgrep() {
    if [ $# -eq 0 ]; then
        echo "usage: vgrep [ pattern ]  # Tries to find and print top-level SODA variables that matches pattern" >&2
        return 1
    fi
    local PATTERN=$1
    find . -type f -path '*_vars/*' | while read FILE; do
        local matches=$(yq -r "to_entries | map(select(.key | match(\"$PATTERN\";\"i\"))) | from_entries" $FILE)
        if [ "$matches" != "{}" ]; then
            echo "==> $FILE <=="
            yq -y -r "to_entries | map(select(.key | match(\"$PATTERN\";\"i\"))) | from_entries" $FILE
            echo
        fi
    done
}

upload ()
{
    for file in "$@";
    do
        aws s3 cp "$file" "s3://folkol.com/$file" --acl public-read-write > /dev/null;
        echo "https://folkol.com/$file";
    done
}

invalidate() {
    local paths=$1
    aws cloudfront create-invalidation --distribution-id EA2XJ4B419376 --paths $paths
}

drop() {
    local num_rows=${1:-1}
    tail -n +$(($num_rows + 1))
}

reduce ()
{
    read x;
    while read y; do
        eval "x=$1";
    done;
    echo $x
}

static_analysis_c() {
    if [ -z $1 ]
    then
        echo "Usage: check_static_analysis source_file.c"
        return;
    fi
    ~/bin/checker-275/scan-build ~/bin/checker-275/bin/clang -c $@
}

xmlgrep()
{
    if [ -z $2 ]
    then
      dir=.
    else
      dir=$2
    fi
    grep -r $1 $dir --include="*.xml"
}

javagrep()
{
    if [ -z $2 ]
    then
      dir=.
    else
      dir=$2
    fi
    grep -r $1 $dir --include="*.java"
}

pushd()
{
    if [ $# -eq 0 ]; then
        DIR="${HOME}"
    else
        DIR="$1"
    fi

    if [ "$DIR" != "$(pwd)" ]; then
        builtin pushd "${DIR}" > /dev/null
    fi
    dirs
}

findinjar() {
    local PATTERN=$1
    if [ -z "$PATTERN" ]; then
        printf "usage: jgrep PATTERN [DIRECTORY]\n"
        return 1
    fi
    local DIR=$2
    if [ -z "$DIR" ]; then
        DIR="${HOME}/.m2/repository/"
    fi
    grep -rFl "$PATTERN" "$DIR" --include=\*jar
}

distinct() {
 awk '!a[$0]++'
}

sum() {
    awk '{ s+=$1 } END { print s }'
}

function pp()
{
    printf "$(pbpaste)\n"
}

function each() {
    while read line; do
        for f in "$@"; do
            $f $line
        done
    done
}

function download() {
    if [ -z "$1" ]; then
        echo 'usage: download filename'
        return 1
    fi
    local resource=$1
    local URL="https://share.folkol.com/files/$resource"
    curl -s -S -o $resource $URL
}

function gmtm() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "    Git, can you hear me?"
        echo "    I am lost and so alone"
        echo "    I'm asking for your guidance"
        echo "    Won't you come down from your throne?"
        echo "    I need a tight compadre"
        echo "    Who will teach me how to rock"
        echo "    My father thinks you're evil"
        echo "    But man, he can suck a <redacted>"
        echo "    Git is not the Devil's work"
        echo "    It's magical and rad"
        echo "    I'll never rock as long as I am"
        echo "    Stuck here with my Dad"
        echo
        echo "...aka 'Not inside git repo?'" >&2
        return
    fi

    local branch="$1"

    if [ -z "$branch" ]; then
        # Assuming that we want to merge current branch to master
        branch="$(git rev-parse --abbrev-ref HEAD)"
    fi

    echo " === MERGING $branch INTO MASTER ===" >&2
    git checkout $branch
    git pull
    git merge origin/master
    git checkout master
    git pull
    git merge $branch
}

### COMPLETIONS

# complete -o bashdefault -E -C folkol_master_completion
complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make
complete -W '$(cat ~/.my_hosts$ivbar_env)' ssh
complete -W "\`gpg -h | egrep -o -- '--\S+'\`" gpg
complete -C 'aws_completer' aws
complete -o default -F __start_kubectl k

for file in /usr/local/etc/bash_completion.d/*; do
    source $file
done

### ALIASES
alias jp='jupyter notebook'
alias vim=_vim
alias vb='vim ~/.bash_profile'
alias gcom='git checkout master'
alias gh='git-hot'
alias mvn-init="mvn archetype:generate -DgroupId=com.folkol -DartifactId=rx -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false"
alias uhp="dsh -c -g prod -- cat /ivbar/nagios/data/unhandled-problems.log 2>/dev/null"
alias urldecode="perl -pe 's/\+/ /g; s/%(..)/chr(hex(\$1))/eg'"
alias k=kubectl
alias kgp='kube-get-pods-all-ns'
alias ka='exec_scmb_expand_args kube-attach'
alias ke='exec_scmb_expand_args kube-exec'
alias kdp='k describe pods'
alias kap='k apply -f'
alias ss=shellcheck
alias egg='gg -E'
alias keycode='{ stty raw min 1 time 20 -echo; dd count=1 2> /dev/null | od -vAn -tx1; stty sane; }'
alias gdm='git diff origin/master'
alias gmm='git merge origin/master'
alias gg='git grep -iI'
alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias funiq="awk '!seen[\$0]++'"
alias mkpasswd='openssl rand -base64 48'
alias v='test -d venv || python3 -m venv venv && . venv/bin/activate'
alias m='cd ~/code/mota'
alias s='cd ~/code/soda/ansible'
alias i='cd ~/ivbar'
alias t='tree -L 3'
alias l=ll
alias kafka-offset="docker exec -it ace.kafka /bin/sh -c '/opt/kafka*/bin//kafka-run-class.sh kafka.tools.GetOffsetShell --topic polopoly.changelist --broker-list localhost:9092' | cut -d: -f3"
alias dockershell='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
alias git-diff-ignore-whitespace='git diff --word-diff-regex=[^[:space:]]'
alias docker-kill-all='docker ps -qa | each "docker stop" "docker rm"'
alias docker-stats-names='docker stats `docker ps --format "{{.Names}}"`'
alias serve='python -m http.server'
alias strip="sed -E 's/^[\t ]*(.*)[\t ]*$/\1/'"
alias gitbranches='git branch -a --sort=-committerdate --color -v | head'
alias ktail='docker exec -it ace.kafka sh -c "/opt/kafka*/bin/kafka-console-consumer.sh --topic polopoly.changelist --zookeeper localhost:2181"'
alias tailall='tail -n+1'
alias haskell=ghci 
alias java6="JAVA_HOME=$(/usr/libexec/java_home -v 1.6 2>/dev/null)"
alias java7="JAVA_HOME=$(/usr/libexec/java_home -v 1.7 2>/dev/null)"
alias java8='JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'
alias java9='JAVA_HOME=$(/usr/libexec/java_home -v 9)'
alias jenkins='java -jar /usr/local/opt/jenkins/libexec/jenkins.war --httpPort=1337'
alias git_share='git daemon --verbose --export-all --enable=upload-pack --enable=receive-pack --base-path=`pwd`'
alias git_daemon='git daemon --verbose --export-all --enable=upload-pack --enable=receive-pack --base-path=`pwd`'
alias cdp="cd ~/polopoly"
alias mvnsystem="sudo ln -s -f /usr/share/maven/bin/mvn /usr/bin/mvn"
alias ll="ls -lhSA"
alias jenkinsup='/usr/bin/java -jar /Applications/Jenkins/jenkins.war --httpPort=7979'
alias deltaup='deltacloudd -i mock'
alias kafka_produce='kafka-console-producer.sh --broker-list localhost:2181 --topic testtest'
alias kafka_consume='kafka-console-consumer.sh --zookeeper localhost:2181 --topic testtest --from-beginning'
alias preview='open -a Preview.app -f'

# MacPorts Installer addition on 2013-01-16_at_14:08:26: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

### ENVIRONMENT
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export SPARK_PATH=/usr/local/opt/spark
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS=notebook
export PYSPARK_PYTHON=python3
export PATH="$HOME/.cargo/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/google-cloud-sdk/path.bash.inc' ]; then source '/opt/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/google-cloud-sdk/completion.bash.inc' ]; then source '/opt/google-cloud-sdk/completion.bash.inc'; fi

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

### NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

### scm_breeze
[ -s "/Users/folkol/.scm_breeze/scm_breeze.sh" ] && source "/Users/folkol/.scm_breeze/scm_breeze.sh"

#### scm_breeze overrides
alias emacs='exec_scmb_expand_args /usr/bin/env emacs'
#complete -o bashdefault -I -C get_era_ticket_initial gc
complete -o bashdefault -C get_era_ticket gc

#### fzf stuff
export FZF_DEFAULT_COMMAND=fd
alias f=fzf

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH
