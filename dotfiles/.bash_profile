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
export JAVA_HOME=`/usr/libexec/java_home`
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

function nitro_import
{
    java -jar ~/polopoly/test/nitro-dist-test-project/target/dist/deployment-config/polopoly-cli.jar import -c http://localhost:9090/connection-properties/connection.properties $@
}

import() {
    cp $@ /Users/folkol/polopoly/sites/greenfieldtimes-example/work/inbox/
}
tatic_analysis_c() {
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

[ -s "/Users/folkol/.scm_breeze/scm_breeze.sh" ] && source "/Users/folkol/.scm_breeze/scm_breeze.sh"

### ALIASES
#alias cd=pushd
alias t='tree -L 3'
alias l=ll
alias plot="gnuplot -p -e \"set nokey; plot '<cat -' with lines\""
alias kafka-offset="docker exec -it ace.kafka /bin/sh -c '/opt/kafka*/bin//kafka-run-class.sh kafka.tools.GetOffsetShell --topic polopoly.changelist --broker-list localhost:9092' | cut -d: -f3"
alias docker-login='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
alias git-diff-ignore-whitespace='git diff --word-diff-regex=[^[:space:]]'
alias docker-kill-all='docker ps -qa | each "docker stop" "docker rm"'
alias docker-stats-names='docker stats `docker ps --format "{{.Names}}"`'
alias serve='python -m SimpleHTTPServer'
alias strip="sed -E 's/^[\t ]*(.*)[\t ]*$/\1/'"
alias gitbranches='git branch -a --sort=-committerdate --color -v | head'
alias emacs='emacsclient'
alias ktail='docker exec -it ace.kafka sh -c "/opt/kafka*/bin/kafka-console-consumer.sh --topic polopoly.changelist --zookeeper localhost:2181"'
alias pp-login='export TOKEN=$(pp-login.sh)'
alias ace-login='export TOKEN=$(/Users/folkol/code/ace/system-tests/test-scripts/bin/ace-login.sh)'
alias ace-login-kalle='export TOKEN=$(/Users/folkol/code/ace/system-tests/test-scripts/bin/ace-login.sh kalle anka)'
alias serve='python -m SimpleHTTPServer'
alias ace-login='export TOKEN=$(ace-login.sh $USERNAME $PASSWD)'
alias tailall='tail -n+1'
alias haskell=ghci 
alias java6="JAVA_HOME=$(/usr/libexec/java_home -v 1.6 2>/dev/null)"
alias java7="JAVA_HOME=$(/usr/libexec/java_home -v 1.7 2>/dev/null)"
alias java8="JAVA_HOME=$(/usr/libexec/java_home -v 1.8)"
alias nitropy="(cd /tmp && JOB_NAME=master_Nightly_nitro-webapps-adapter-tomcat-jboss5-mysql /Users/folkol/test-environment/script/nitro/nitro.py --tomcatDebug --jbossDebug -d -k -p ~/polopoly/)"
alias pp_reinstall='time (killall java; rm -r /tmp/test-dir; pp && git clean -df && ./jrebel-gen.py -c && mvn clean install -DskipTests -Dskipdb && JOB_NAME="_nitro-system-jboss-mysql-tomcat" ~/test-environment/script/nitro/nitro.py -d -k --tomcatDebug --jbossDebug -p ~/polopoly/ -j ~/jrebel)'
alias jenkins='java -jar /usr/local/opt/jenkins/libexec/jenkins.war --httpPort=1337'
alias reindex='java -jar /Users/folkol/polopoly/sites/greenfieldtimes-example/target/dist/deployment-config/polopoly-cli.jar reindex -a -s http://localhost:8080/solr-indexer'
alias pc='cd ~/code/photochallenge_play'
alias pp='cd ~/code/polopoly'
alias te='cd ~/code/test-environment'
alias gt='pp && cd sites/greenfieldtimes-example'
alias ace='cd ~/code/ace'
alias tidyjson="python -m json.tool"
alias git_share='git daemon --verbose --export-all --enable=upload-pack --enable=receive-pack --base-path=`pwd`'
alias git_daemon='git daemon --verbose --export-all --enable=upload-pack --enable=receive-pack --base-path=`pwd`'
alias import_scan="mvn p:import-scan -Dpolopoly.connection-properties=http://localhost:8081/connection-properties/connection.properties"
alias cdp="cd ~/polopoly"
alias deploy_external='cp target/dist/deployment-cm/cm-server*.ear /usr/local/jboss/jboss-4.0.5.GA/server/default/deploy/polopoly/ && cp target/dist/deployment-front/*.war /Library/Tomcat/Home/webapps/ && cp target/dist/deployment-polopoly-gui/*.war /Library/Tomcat/Home/webapps/'
alias rebel='MAVEN_OPTS="-noverify -agentpath:$REBEL_HOME/lib/libjrebel64.dylib $MAVEN_OPTS"'
alias p_run='rebel mvnDebug p:run -Dpolopoly.jetty-scanIntervalSeconds=0 -DskipTests'
alias pp_run='MAVEN_OPTS="-noverify -Xbootclasspath/p:$REBEL_HOME/jrebel-bootstrap.jar:$REBEL_HOME/jrebel.jar -DPP_HOME=/Users/folkol -Drebel.plugins=/Users/folkol/pp-rebel/pp-rebel/target/pp-rebel-1.1-SNAPSHOT-jar-with-dependencies.jar -Drebel.pp-rebel=true $MAVEN_OPTS" mvnDebug p:run -Dpolopoly.jetty-scanIntervalSeconds=0'
alias mvn305="export PATH=/usr/local/opt/maven-3.0.5/bin:$PATH"
alias mvn311="brew switch maven 3.1.1 && export PATH=/usr/local/bin:$PATH"
alias mvnsystem="sudo ln -s -f /usr/share/maven/bin/mvn /usr/bin/mvn"
alias ll="ls -lhSA"
#alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias jenkinsup='/usr/bin/java -jar /Applications/Jenkins/jenkins.war --httpPort=7979'
alias deltaup='deltacloudd -i mock'
alias kff="ps ax | grep firefox | grep -v grep | awk ' {print \$1}' | xargs kill"
alias deployjs="ant -f ~/polopoly/dist/build.xml pack-polopoly-js -Djs.compress=false && cp -r ~/polopoly/dist/dist-root/install/web/jsp.orchid/script/* /Library/Tomcat/Home/webapps/polopoly/script/ && echo '  -- Kopierat och klart! --'"
alias jup='/Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home/bin/java -Dprogram.name=run.sh -DconnectionPropertiesFile=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/config/connection.properties -Djava.util.logging.config.file=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/config/logging.properties -Dp.ejbConfigurationUrl=file:///var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/config/ejb-configuration.properties -Dp.connectionPropertiesUrl=file:///var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/config/connection.properties -DclientCacheBaseDir=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/clientcaches -Djava.rmi.server.hostname=localhost -noverify -javaagent:/Users/folkol/jrebel/jrebel.jar -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n -Dsolr.solr.home=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T//test-dir/solrHome -server -Xms256m -Xmx1536m -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -XX:PermSize=64m -XX:MaxPermSize=512m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000 -Djava.util.logging.config.file=/opt/jboss4/bin/solr-logging.properties -Dcom.sun.management.jmxremote.port=8088 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.endorsed.dirs=/opt/jboss4/lib/endorsed -classpath /opt/jboss4/bin/run.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home/lib/tools.jar org.jboss.Main -c server_mysql_extweb & >> /opt/jboss/out.log'
alias tup='/Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home/bin/java -Djava.util.logging.config.file=/opt/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.awt.headless=true -DreindexIfEmptyIndex=true -Djava.util.logging.config.file=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/config/logging.properties -Dp.connectionPropertiesUrl=http://localhost:9090//connection-properties/connection.properties -Dcontent-file-service-directory=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/files/content -Dtemporary-file-service-directory=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/files/temporary -Dsolr.solr.home=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/solrHome -Dnitro.workspace=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/filedata -Dnitro.applicationContextLocation=file:///var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/config/server-integration.applicationContext.xml -Dnitro.integrationInboxLocation=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/inbox -Dnitro.integrationInboxWithApplicationsLocation=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/inbox-with-applications -Dnitro.integrationOutboxLocation=/var/folders/sn/pr23sfmj305695dfj3m4p2lw0000gn/T/test-dir/outbox -DmultimachineTest.indexServerHost=http://localhost:8080 -DejbContainerJmxUrl=service:jmx:rmi:///jndi/rmi://localhost:8088/jmxrmi -DwebContainerJmxUrl=service:jmx:rmi:///jndi/rmi://localhost:8088/jmxrmi -DPOLOPOLY_TEST_REPORT_DIR=/Users/folkol/polopoly/archive/dumps/ -DwebServerHost=localhost -DwebDataApiServerHost=localhost -DwebDataApiServerPort=8080 -DcachingProxy=False -noverify -javaagent:/Users/folkol/jrebel/jrebel.jar -Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n -DclientCacheBaseDir=/tmp/test-dir/clientcaches -Xms128m -Xmx2048m -XX:PermSize=64m -XX:MaxPermSize=512m -Dcom.sun.management.jmxremote.port=8089 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.endorsed.dirs=/opt/tomcat/endorsed -classpath /opt/tomcat/bin/bootstrap.jar:/opt/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/opt/tomcat -Dcatalina.home=/opt/tomcat -Djava.io.tmpdir=/opt/tomcat/temp org.apache.catalina.startup.Bootstrap start & >> /opt/tomcat/logs/catalina.out'S
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

