echo "Now executing ~/.bash_profile"

# BASH SETTINGS
# ... or force ignoredups and ignorespace
#export HISTCONTROL=ignoreboth

#Rebind terminal flow control to ^X instead of ^S to enable bash forward search
stty stop ^X

# append to the history file, don't overwrite it
#shopt -s histappend
#PROMPT_COMMAND="history -n; history -a"
unset HISTFILESIZE
HISTSIZE=2000
export CLICOLOR=Hxxxbxxxxxx

### PATH
export PATH=$PATH:/Users/folkol/bin/scripts:/Users/folkol/bin/polopoly_scripts:/Users/folkol/bin
export PATH=/usr/bin/wget:/usr/local/apache-maven/apache-maven-2.2.1/bin/mvn:/usr/local/sbin:$PATH
export PATH=$PATH:/Applications/JD-GUI.app/Contents/MacOS
export PATH=/usr/local/bin:$PATH

### IMPORTS
source ~/bin/git-completion.bash

### EXPORTS
export PS1='\n`pwd`\n[\u@\h$(__git_ps1 " (%s)")]\$ '
export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
export ANT_OPTS=-'Xmx512m -XX:MaxPermSize=128m'
export EDITOR=emacs
export MY_POLOPOLY_HOME=/Users/folkol/polopoly
export MY_POLOPOLY_DIST=$MY_POLOPOLY_HOME/dist
export MY_POLOPOLY_DIST_ROOT=$MY_POLOPOLY_DIST/dist-root
export AWK_COL_TO_PRINT=$1
export REBEL_HOME="/Users/folkol/jrebel/"
export MAVEN_OPTS="-Xmx1536m -Xms128m -XX:PermSize=128m -XX:MaxPermSize=256m"
export ANT_OPTS=-Xmx1024m

### FUNCTIONS
import() {
    cp $@ /Users/folkol/polopoly/sites/greenfieldtimes-example/work/inbox/
}

rmhost() {
    if [ $# -eq 0 ]
    then
        echo "Usage: rmhost ip"
        return
    fi
    cat ~/.ssh/known_hosts | grep -v $1 > ~/.ssh/known_hosts.tmp && mv ~/.ssh/known_hosts.tmp ~/.ssh/known_hosts
}

static_analysis_c() {
    if [ -z $1 ]
    then
        echo "Usage: check_static_analysis source_file.c"
        return;
    fi
    ~/bin/checker-275/scan-build ~/bin/checker-275/bin/clang -c $@
}

### ALIASES
alias tidyjson="python -m json.tool"
alias git_share='git daemon --verbose --export-all --enable=upload-pack --enable=receive-pack --base-path=`pwd`'
alias git_daemon='git daemon --verbose --export-all --enable=upload-pack --enable=receive-pack --base-path=`pwd`'
alias import_scan="mvn p:import-scan -Dpolopoly.connection-properties=http://localhost:8081/connection-properties/connection.properties"
alias cdp="cd ~/polopoly"
alias deploy_external='cp target/dist/deployment-cm/cm-server*.ear /usr/local/jboss/jboss-4.0.5.GA/server/default/deploy/polopoly/ && cp target/dist/deployment-front/*.war /Library/Tomcat/Home/webapps/ && cp target/dist/deployment-polopoly-gui/*.war /Library/Tomcat/Home/webapps/'
alias rebel='MAVEN_OPTS="-noverify -javaagent:$REBEL_HOME/jrebel.jar $MAVEN_OPTS"'
alias p_run='rebel mvnDebug p:run -Dpolopoly.jetty-scanIntervalSeconds=0 -DskipTests'
alias pp_run='MAVEN_OPTS="-noverify -Xbootclasspath/p:$REBEL_HOME/jrebel-bootstrap.jar:$REBEL_HOME/jrebel.jar -DPP_HOME=/Users/folkol -Drebel.plugins=/Users/folkol/pp-rebel/pp-rebel/target/pp-rebel-1.1-SNAPSHOT-jar-with-dependencies.jar -Drebel.pp-rebel=true $MAVEN_OPTS" mvnDebug p:run -Dpolopoly.jetty-scanIntervalSeconds=0'
alias mvn2="sudo ln -s -f /usr/share/java/maven-2.2.1/bin/mvn /usr/bin/mvn"
alias mvn3="sudo ln -s -f /usr/share/java/maven-3.0.4/bin/mvn /usr/bin/mvn"
alias mvnsystem="sudo ln -s -f /usr/share/maven/bin/mvn /usr/bin/mvn"
alias ll="ls -l"
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias jenkinsup='/usr/bin/java -jar /Applications/Jenkins/jenkins.war --httpPort=7979'
alias deltaup='deltacloudd -i mock'
alias kff="ps ax | grep firefox | grep -v grep | awk ' {print \$1}' | xargs kill"
alias deployjs="ant -f ~/polopoly/dist/build.xml pack-polopoly-js -Djs.compress=false && cp -r ~/polopoly/dist/dist-root/install/web/jsp.orchid/script/* /Library/Tomcat/Home/webapps/polopoly/script/ && echo '  -- Kopierat och klart! --'"
alias maketomcatsoftlink='ln -s /Users/folkol/polopoly/eclipse-build/com /Library/Tomcat/Home/webapps/polopoly/WEB-INF/classes/com'
alias jup='/usr/local/jboss/jboss-4.0.5.GA/bin/run.sh'
alias tup='/Library/Tomcat/Home/bin/catalina.sh jpda start'
alias tjup='/Library/Tomcat/Home/bin/catalina-jrebel.sh jpda start'
alias tdown='/Library/Tomcat/Home/bin/catalina.sh stop'
alias tlog='tail -F -b 200 /Library/Tomcat/Home/logs/catalina.out'
alias pup='/Users/folkol/polopoly/dist/dist-root/bin/polopoly start'
alias pdown='/Users/folkol/polopoly/dist/dist-root/bin/polopoly stop'
alias copyjars="cp /usr/local/jboss/jboss-4.0.5.GA/client/concurrent.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jboss-client.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jboss-common-client.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jbossha-client.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jboss-j2ee.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jbossmq-client.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jbosssx-client.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jboss-system-client.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jboss-transaction-client.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jboss-serialization.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jboss-remoting.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jmx-client.jar \
                   /usr/local/jboss/jboss-4.0.5.GA/client/jnp-client.jar \
                   ~/polopoly/dist/dist-root/contrib-archives/container-client-lib/"

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