# BASH SETTINGS
# ... or force ignoredups and ignorespace
#export HISTCONTROL=ignoreboth

#Rebind terminal flow control to ^X instead of ^S to enable bash forward search
stty stop undef
stty start undef

# append to the history file, don't overwrite it
#shopt -s histappend
#PROMPT_COMMAND="history -n; history -a"
unset HISTFILESIZE
HISTSIZE=2000
export CLICOLOR=Hxxxbxxxxxx

### Docker machine env
#eval $(docker-machine env default)

### PATH
export PATH=$PATH:/Users/folkol/bin/scripts:/Users/folkol/bin/polopoly:/Users/folkol/bin
export PATH=/usr/bin/wget:/usr/local/apache-maven/apache-maven-2.2.1/bin/mvn:/usr/local/sbin:$PATH
export PATH=$PATH:/Applications/JD-GUI.app/Contents/MacOS
export PATH=/usr/local/bin:$PATH
export PATH="/Users/folkol/code/ace/system-tests/test-scripts/bin:$PATH"
export PATH="$PATH:/Users/folkol/Library/Python/2.7/bin"

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

[ -s "/Users/folkol/.scm_breeze/scm_breeze.sh" ] && source "/Users/folkol/.scm_breeze/scm_breeze.sh"

### ALIASES
alias t='tree -L 3'
alias l=ll
alias kafka-offset="docker exec -it ace.kafka /bin/sh -c '/opt/kafka*/bin//kafka-run-class.sh kafka.tools.GetOffsetShell --topic polopoly.changelist --broker-list localhost:9092' | cut -d: -f3"
alias dockershell='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
alias git-diff-ignore-whitespace='git diff --word-diff-regex=[^[:space:]]'
alias docker-kill-all='(ace; docker-compose -f system-tests/test-scripts/docker-compose.yml down; docker ps -qa | each "docker stop" "docker rm";)'
alias docker-stats-names='docker stats `docker ps --format "{{.Names}}"`'
alias serve='python -m SimpleHTTPServer'
alias strip="sed -E 's/^[\t ]*(.*)[\t ]*$/\1/'"
alias gitbranches='git branch -a --sort=-committerdate --color -v | head'
alias ktail='docker exec -it ace.kafka sh -c "/opt/kafka*/bin/kafka-console-consumer.sh --topic polopoly.changelist --zookeeper localhost:2181"'
alias serve='python -m SimpleHTTPServer'
alias tailall='tail -n+1'
alias haskell=ghci 
alias jenkins='java -jar /usr/local/opt/jenkins/libexec/jenkins.war --httpPort=1337'
alias git_share='git daemon --verbose --export-all --enable=upload-pack --enable=receive-pack --base-path=`pwd`'
alias git_daemon='git daemon --verbose --export-all --enable=upload-pack --enable=receive-pack --base-path=`pwd`'
alias cdp="cd ~/polopoly"
alias rebel='MAVEN_OPTS="-noverify -agentpath:$REBEL_HOME/lib/libjrebel64.dylib $MAVEN_OPTS"'
alias mvnsystem="sudo ln -s -f /usr/share/maven/bin/mvn /usr/bin/mvn"
alias ll="ls -lhSA"
alias jenkinsup='/usr/bin/java -jar /Applications/Jenkins/jenkins.war --httpPort=7979'
alias deltaup='deltacloudd -i mock'
alias zup='/opt/zookeeper/bin/zkServer.sh start'
alias kup='/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties'
alias pup='zup && kup && jup && tup'

alias tlog='tail -F -b 200 /Library/Tomcat/Home/logs/catalina.out'
alias kafka_produce='kafka-console-producer.sh --broker-list localhost:2181 --topic testtest'
alias kafka_consume='kafka-console-consumer.sh --zookeeper localhost:2181 --topic testtest --from-beginning'
alias preview='open -a Preview.app -f'

#sourcing rvm
#source /Users/folkol/.rvm/scripts/rvm
##
# Your previous /Users/folkol/.bash_profile file was backed up as /Users/folkol/.bash_profile.macports-saved_2013-01-16_at_14:08:26
##

# MacPorts Installer addition on 2013-01-16_at_14:08:26: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

### ENVIRONMENT
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

source ~/git-completion.bash

