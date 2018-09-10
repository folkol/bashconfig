# Leave my ^S alone!
stty stop undef
stty start undef

### HISTORY COMMANDS

shopt -s histappend
PROMPT_COMMAND="history -n; history -a; $PROMT_COMMAND"
export HISTCONTROL=ignoreboth
export HISTFILESIZE=
export HISTSIZE=
export CLICOLOR=Hxxxbxxxxxx

### PATH

#export PATH=$(brew --prefix openssl)/bin:$PATH
export PATH="/usr/local/opt/openssl:$PATH"
export PATH=$PATH:/Users/folkol/bin/scripts:/Users/folkol/bin/polopoly:/Users/folkol/bin
export PATH=/usr/bin/wget:/usr/local/apache-maven/apache-maven-2.2.1/bin/mvn:/usr/local/sbin:$PATH
export PATH=$PATH:/Applications/JD-GUI.app/Contents/MacOS
export PATH=/usr/local/bin:$PATH
export PATH="/Users/folkol/code/ace/system-tests/test-scripts/bin:$PATH"
export PATH="$PATH:/Users/folkol/Library/Python/2.7/bin"
export PATH="$PATH:/Users/folkol/code/futils/bin"
export PATH="/usr/local/opt/flex/bin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/opt/texinfo/bin/:$PATH"
export PATH="/Users/folkol/code/futils/bin:$PATH"
export PATH="$(brew --prefix)/opt/python/libexec/bin:$PATH"

### IMPORTS
source ~/.bashrc

### EXPORTS
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

export DEBUG='-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address='

### FUNCTIONS

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
    awk '{ s+=$1 } END { print $1 }'
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

function upload() {
    if [ -z "$1" ]; then
        echo 'usage: upload filename [ resource_name ]'
        return 1
    fi
    local filename=$1
    local resource=${2:-$filename}
    local URL="https://share.folkol.com/files/$resource"
    curl -s -S -o /dev/null -XPUT --data-binary @$filename $URL
    echo $URL
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

complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make
complete -W '$(cat ~/.my_hosts)' ssh

### ALIASES
alias keycode='{ stty raw min 1 time 20 -echo; dd count=1 2> /dev/null | od -vAn -tx1; stty sane; }'
alias gdm='git diff origin/master'
alias gmm='git merge origin/master'
alias gg='git grep -I'
alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias funiq="awk '!seen[\$0]++'"
alias mkpasswd='openssl rand -base64 16'
alias v='test -d venv || python3 -m venv venv && . venv/bin/activate'
alias m='cd ~/code/mota'
alias s='cd ~/code/soda'
alias i='cd ~/ivbar'
alias t='tree -L 3'
alias l=ll
alias kafka-offset="docker exec -it ace.kafka /bin/sh -c '/opt/kafka*/bin//kafka-run-class.sh kafka.tools.GetOffsetShell --topic polopoly.changelist --broker-list localhost:9092' | cut -d: -f3"
alias dockershell='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
alias git-diff-ignore-whitespace='git diff --word-diff-regex=[^[:space:]]'
alias docker-kill-all='docker ps -qa | each "docker stop" "docker rm"'
alias docker-stats-names='docker stats `docker ps --format "{{.Names}}"`'
alias serve='python -m SimpleHTTPServer'
alias strip="sed -E 's/^[\t ]*(.*)[\t ]*$/\1/'"
alias gitbranches='git branch -a --sort=-committerdate --color -v | head'
alias ktail='docker exec -it ace.kafka sh -c "/opt/kafka*/bin/kafka-console-consumer.sh --topic polopoly.changelist --zookeeper localhost:2181"'
alias serve='python -m SimpleHTTPServer'
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
alias plot="gnuplot -p -e 'term=system(\"echo ${TERMINAL:-dumb}\"); set terminal term; plot \"< cat -\";'"

# MacPorts Installer addition on 2013-01-16_at_14:08:26: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

### ENVIRONMENT
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

source ~/git-completion.bash


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
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
