# Leave my ^S alone!
# if tty -s; then
stty stop undef 2>/dev/null
stty start undef 2>/dev/null
# fi

### HISTORY COMMANDS

shopt -s histappend
shopt -s globstar
PROMPT_COMMAND="history -n; history -a; $PROMPT_COMMAND"
export HISTCONTROL=ignoreboth
export HISTFILESIZE=
export HISTSIZE=9999999
export CLICOLOR=Hxxxbxxxxxx
export HISTTIMEFORMAT="%d/%m/%y %T "

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
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/Users/folkol/bin:/Users/folkol/bin/scripts:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="$HOME/Library/Python/3.7/bin/:$PATH"
export PATH="$HOME/Library/Python/3.6/bin/:$PATH"
export PATH="$PATH:~/.tacit"
export PATH="$PATH:/opt/homebrew/bin/"

### IMPORTS
source ~/.bashrc ### EXPORTS
export PS1='\[\033[1;31m\]♥\[\033[0m\] '
#PROMPT_COMMAND='BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)'
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

function todo() {
    if [[ $# == 0 ]]; then
        vim ~/Documents/notes/todos
    else
        echo "$@" >>~/Documents/notes/todos
    fi
}

function todos() {
    if [[ $# == 0 ]]; then
        echo "=== found in notes ==="
        rg TODO ~/Documents/notes
        echo
        echo "=== explicit ==="
        sed 's/^/- /' ~/Documents/notes/todos
    else
        echo "$@" >>~/Documents/notes/todos
    fi
}

function tscc() {
    local tmpdir=$(mktemp -d)
    if [[ $# == 0 ]]; then
        local infile="$tmpdir/main.ts"
        cat >$infile
    else
        local infile=$1
    fi
    local outfile="$tmpdir/main.js"
    npx tsc --pretty --out "$outfile" "$infile"
    vimcat -c 'set syntax=JavaScript' "$outfile"
}

function cdk-redeploy() {
    [[ $# > 0 ]] || {
        echo "usage: cdk-deploy '\$stack'"
        return 1
    }
    local stack=$1
    (
        cd "$(git rev-parse --show-toplevel)/deploy" && aws-vault exec qwaya -- yarn cdk deploy -e "$stack"
    )
}

summary() {
    local query="$(urlencode "$@")"
    curl -s "https://api.duckduckgo.com/?format=json&q=$query" | jq -r .Abstract | fold -s -w 72
}

bb-ss () {
    {
        echo '#!/bin/bash'
        yq e 'explode(.) | .pipelines.*.*[] | (.step, .parallel[]) | .script[]' bitbucket-pipelines.yml
    } | shellcheck -
}

git-pretty-format() {
    echo "%n          newline"
    echo "%%          %"
    echo "%x00        hex byte (e.g. %x09 for horizontal tab)"
    echo "%C...       color specification, red|green|blue|reset or C(...) see git-config Value>color"
    echo "%[><](<N>)  padding, optional truncation with %<(N,[lm]trunc)"
    echo "%h, %H      (abbr) commit hash"
    echo "%t, %T      (abbr) tree hash"
    echo "%p, %P      (abbr) parent hashes"
    echo "%[ac][ne]   author/committer name/email"
    echo "%[ac][Is]   author/committer date (short/ISO)"
    echo "%[fs]       (sanitized) subject"
    echo "%[bB]       body (raw)"
    echo ""
    echo "For more placeholders, see man git-log."
}

git-time-travel() {
    git log "${1:-origin/master}" --reverse --pretty=format:%h \
        | while read -r NEXT; do 
            read -rsn1 -p "Press any key to checkout $NEXT: " </dev/tty
            git checkout "$NEXT"
        done
}

# https://stackoverflow.com/a/37840948/2201050
# function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

# https://gist.github.com/cdown/1163649

urlencode() {
    local input="$@"
    local length="${#input}"
    for (( i = 0; i < length; i++ )); do
        local c="${input:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) LC_COLLATE=C printf '%s' "$c" ;;
            *) LC_COLLATE=C printf '%%%02X' "'$c" ;;
        esac
    done
}

urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

h ()
{
    if [ $# -eq 0 ]; then
        ls -d -1 ~/Library/Containers/com.folkol.MenuBarHint/Data/Library/Application\ Support/MenuBarHint/* 2>/dev/null || echo '[no hints, add with "h somehint"]'
    else
        touch ~/Library/Containers/com.folkol.MenuBarHint/Data/Library/Application\ Support/MenuBarHint/"$*";
    fi
}

rust-desugar() {
    rustc +nightly -Zunpretty=hir "$@" \
        | rustfmt \
        | vimcat -c 'set syntax=rust'
}

hl() {
    local pattern=$1
    shift
    grep --color -e ".*$pattern.*" -e '$' "$@"
}

# Recursively display a vault subtree (bash + jq)
vault_tree ()
{
    # usage
    if [ $# -eq 0 ] || [[ ! $1 == */ ]]; then
        echo "usage: vault_tree ROOT/ (e.g. /secret/admin/, /secret/backup/ or /secret/shared/ -- including trailing slash)" >&2
        return 1
    fi

    # color highlighting
    if [ -t 1 ]; then
        BEGIN="\e[34m\e[1m"
        END="\e[0m"
    else
        BEGIN=""
        END=""
    fi

    # main
    local current=$1
    local root=$2
    local indent=$3
    echo -e "$indent$BEGIN${current#$root}$END"
    for child in $(vault kv list -format json "$current" | jq -r .[]); do
        if [[ $child == */ ]]; then
           vault_tree "$current$child" "$current" "$indent    "
        else
            echo -e "$indent    - $child"
        fi
    done
}

# Parse date and print out parts in tabular form
pd ()
{
    local when=${1:-$(date)};
    gdate -d "$when" '+%A %Y %m %d %H %M %S %z %s'
}

function pyupid ()
{
    local BASE_URL=https://raw.githubusercontent.com/pyupio/safety-db/master/data/
    local DB_NAME=insecure_full.json
    local DB_FILENAME=~/.safety-db-$DB_NAME

    if [ ! $# -eq 1 ]; then
        echo "usage: pyupid advisoryid";
        return 1;
    fi

    local advisoryid=$1

    if ! find $DB_FILENAME -mtime -30 2> /dev/null | grep -q .; then
        echo 'old db, updating...';
        curl -sS $BASE_URL$DB_NAME > ~/.safety-db-$DB_NAME
    fi

    jq 'del(."$meta") | to_entries[].value[] | select(.id == "pyup.io-'$advisoryid'")' $DB_FILENAME
}

function geoip_lookip ()
{
    curl -s https://ipinfo.io/$1
}

function allcerts() {
    if [ $# -ne 1 ]; then
        echo "usage: allcerts /path/to/bundle.pem"
        return 1
    fi
    openssl crl2pkcs7 -nocrl -certfile "$1" | openssl pkcs7 -print_certs -text -noout
}

getcert() {
    if [ $# -eq 0 ]; then
        echo "Missing servername" >&2
        return 1
    fi

    </dev/null openssl s_client -connect "$1:443" | openssl x509 -noout -text
}
news ()
{
    curl -s 'https://newsapi.org/v2/top-headlines?language=en' \
        -G \
        -d @/Users/folkol/.newsapi.key \
        | jq -r '.articles[] | "\(.title)\t\(.url)"' \
        | column -s$'\t' -t
}

function ykotp() {
    # https://demo.yubico.com/otp/verify
    OTP="$1"
    if [ $# -lt 1 ]; then
        read -p "OTP: " -r OTP
    fi
    curl -H'Content-Type: application/json' -d "{\"key\":\"$OTP\"}" https://demo.yubico.com/api/v1/simple/otp/validate
}

function retry ()
{
    if [ $# -eq 0 ]; then
        set -- $(rc -r)
    fi
    until "$@"; do
        sleep 1;
    done
}

function show() {
    vimcat `which "$1"`
}

function npmadvisory() {
   if [ $# != 1 ]; then
      echo "usage: npmadvisory #" >&2
      return
   fi
   open https://npmjs.com/advisories/$1
}

function era() {
    [ $# = 0 ] && open 'https://logexgroup.atlassian.net/secure/RapidBoard.jspa?rapidView=538&projectKey=ERA'
    [ -n "$1" ] && open https://logexgroup.atlassian.net/browse/ERA-$1
}

function sc() {
    [ $# = 0 ] && open 'https://github.com/koalaman/shellcheck'
    [ -n "$1" ] && open "https://github.com/koalaman/shellcheck/wiki/SC$1"
}

hnt() {
    head "$@"
    echo "..."
    tail "$@"
}

function get_era_ticket_initial() {
    if ! \git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local ticket=$(echo $branch | grep -Eo '^era-[0-9]+')
    echo "gc -m '$ticket:"
}

function get_era_ticket() {
    if ! \git rev-parse --is-inside-work-tree &>/dev/null; then
        return
    fi
    local branch=$(git rev-parse --abbrev-ref HEAD)
    local ticket=$(echo $branch | grep -Eo '^era-[0-9]+')
    if [ -n "$ticket" ]; then
        ticket="$ticket: "
    fi
    COMPREPLY=("-m '$ticket")
    compopt -o nospace
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

function kube-get-contexts() {
    mapfile <<<$(kubectl config get-contexts)

    i=0
    for line in "${MAPFILE[@]}"; do
        read NAME _ <<<$(echo "$line" | cut -c 11-)
        declare -g e$((i++))="$NAME"
    done

    i=0
    for line in "${MAPFILE[@]}"; do
        if [[ $i -gt 0 ]]; then
            echo -n "[$((i))] $line"
        else
            echo -n "    $line"
        fi
        (( i++ ))
    done
}

function kube-get-pods-all-ns() {
    mapfile -s 1 <<<$(kubectl get pods --all-namespaces | grep -v kube-system)

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

function kube-get-pods() {
    if [[ -z "$NAMESPACE" ]]; then
        local NAMESPACE=${1:-default}
    fi
    mapfile -s 1 <<<$(kubectl get pods --namespace "$NAMESPACE")

    i=1
    for line in "${MAPFILE[@]}"; do
        read NAME READY STATUS RESTARTS AGE <<<$(echo $line)
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

function kube-desc() {
    kubectl describe $1 $2 $3 $4
}

function kube-kill() {
    kubectl delete $1 $2 $3 $4
}

function kube-logs() {
    kubectl logs $1 $2 $3 $4
}

function git_branch_grep() {
    local pattern=${1:-''}
    local i=1
    for ref in $(git branch --list | grep -m 10 "$pattern"); do
        echo "  [$i] $ref"
        declare -g "e$((i++))=${ref#*/}"
    done
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
        "$@" $line
    done
}

function repeat() {
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

for file in /usr/local/etc/bash_completion.d/* /opt/homebrew/etc/bash_completion.d/*; do
    source $file
done 2>/dev/null

### ALIASES
alias td=todo
alias vimtodo="vim ~/Documents/notes/todos"
alias chars='grep -o .'
alias upper='tr [:lower:] [:upper:]'
alias lower='tr [:upper:] [:lower:]'
alias markdown-render='npx termd'
alias snippets=tldr  # online page with command line snippets tldr.sh
alias perltoc='man perltoc'
alias perllint=perlcritic
alias safety-db='pyupid'
alias vimcatyaml='vimcat -c "set syntax=yaml"'
alias kcs='fzf <~/.kubectl-cheat-sheet'
alias jsonpaths='jq -rc "path(..)|[.[]|tostring]|join(\".\")"'
alias d='date "+%Y-%m-%d"'
alias kgetall='kubectl get namespace,replicaset,secret,nodes,job,daemonset,statefulset,ingress,configmap,pv,pvc,service,deployment,pod --all-namespaces'
alias which='echo type'
alias banner=figlet
alias gn='git next'
alias gp='git prev'
alias nowrap='less -SE'
alias dockerlogs='/usr/bin/log stream --style syslog --level=debug --color=always --predicate "process matches \".*(ocker|vpnkit).*\" || (process in {\"taskgated-helper\", \"launchservicesd\", \"kernel\"} && eventMessage contains[c] \"docker\")"'
alias hightlight='HIGHLIGHT_OPTIONS="-O xterm256" highlight'  # brew install highlight
alias cert='openssl x509 -noout -text'
alias allcerts='openssl crl2pkcs7 -nocrl -certfile /dev/stdin | openssl pkcs7 -print_certs -text -noout'
alias securedbid=pyupid
alias vault-login='vault login -no-print -method=userpass username=matte'
alias vault-logout='vault token revoke -self'
alias vecka='date +"%U"'
alias dns-cache-clear='sudo killall -HUP mDNSResponder'
alias docker-for-mac-linux-vm='docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh'
alias ocr=tesseract
alias ruler='echo "0....|....1....|....2....|....3....|....4....|....5....|....6....|....7....|....8....|....9....|....a"'
alias gitauthors='git log --pretty=format:%an | sort | uniq -c | sort -rn'
alias man='MANWIDTH=100 LESSOPEN="|- pr -to $(( ($(tput cols) - 100) / 2)) %s" man'
alias mkpassphrase='echo $(gshuf --random-source=/dev/random -n 3 /usr/share/dict/words | sed "N;N;s/\n/ /g")'
# commented out because it breaks buffer switching in less, e.g. h -> q
#alias man='MANWIDTH=100 LESSOPEN="|- pr -to $(( ($(tput cols) - 100) / 2))" man'
alias fingerprint='ssh-keygen -l -E md5 -f'
alias pg='pgrep -fil'
alias nmap-help='echo https://securitytrails.com/blog/top-15-nmap-commands-to-scan-remote-hosts'
alias osenv='env | grep ^OS_ | grep -v OS_PASSWORD'
alias noos='unset ${!OS_@}'
# alias whatismyip='curl -s https://api.ipify.org'
alias whatismyip='dig -4 @resolver1.opendns.com myip.opendns.com +short'
alias whatismyipgoogle='dig TXT +short o-o.myaddr.l.google.com @ns1.google.com'
alias pcat=pygmentize
alias passphrase='gshuf /usr/share/dict/words | head -n 3 | tr "\n" " "'
#alias todo='gg todo'
alias jp='jupyter notebook'
alias vb='vim ~/.bash_profile'
alias gcom='git checkout master'
alias gh='git-hot'
alias mvn-init="mvn archetype:generate -DgroupId=com.folkol -DartifactId=rx -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false"
alias uhp="dsh -c -g prod -- cat /ivbar/nagios/data/unhandled-problems.log 2>/dev/null"
#alias urldecode="perl -pe 's/\+/ /g; s/%(..)/chr(hex(\$1))/eg'"
alias k=kubectl
alias kgpa='kube-get-pods-all-ns'
alias kgp='kube-get-pods'
alias kl='exec_scmb_expand_args kube-logs'
alias ka='exec_scmb_expand_args kube-attach'
alias ke='exec_scmb_expand_args kube-exec'
alias kd='exec_scmb_expand_args kube-desc pod'
alias kk='exec_scmb_expand_args kube-kill pod'
alias ka='exec_scmb_expand_args kubectl apply -f'
alias kgc='kube-get-contexts'
alias kuc='exec_scmb_expand_args kubectl config use-context'
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
alias s='cd /Users/folkol/code/soda/ansible'
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
#todo=~/Documents/notes/todos
#export LESS='-iMFXRj4#10'
export LESS='-iMFXRj4a#10'
export LESS='-iMXRj4#10'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export REACT_EDITOR=webstorm
export SPARK_PATH=/usr/local/opt/spark
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS=notebook
export PYSPARK_PYTHON=python3
export VAULT_ADDR=https://vault.ivbar.com:8200

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# pipx PATH
PATH="$PATH:/Users/folkol/.local/bin"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

function update_ps_1() {
    echo "Updating PS1"
}
export -f update_ps_1

### NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#### fzf stuff
export FZF_DEFAULT_COMMAND=fd
alias f=fzf

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# Created by `userpath` on 2020-08-07 19:24:13
export PATH="$PATH:/Users/folkol/.local/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

### From pyenv init output

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

#### From https://gist.github.com/frnhr/dba7261bcb6970cf6121

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
pyenvVirtualenvUpdatePrompt() {
    RED='\[\e[0;31m\]'
    GREEN='\[\e[0;32m\]'
    BLUE='\[\e[0;34m\]'
    RESET='\[\e[0m\]'
    [ -z "$PYENV_VIRTUALENV_ORIGINAL_PS1" ] && export PYENV_VIRTUALENV_ORIGINAL_PS1="$PS1"
    [ -z "$PYENV_VIRTUALENV_GLOBAL_NAME" ] && export PYENV_VIRTUALENV_GLOBAL_NAME="$(pyenv global)"
    VENV_NAME="$(pyenv version-name)"
    VENV_NAME="${VENV_NAME##*/}"
    GLOBAL_NAME="$PYENV_VIRTUALENV_GLOBAL_NAME"

    # non-global versions:
    COLOR="$BLUE"
    # global version:
    [ "$VENV_NAME" == "$GLOBAL_NAME" ] && COLOR="$RED"
    # virtual envs:
    [ "${VIRTUAL_ENV##*/}" == "$VENV_NAME" ] && COLOR="$GREEN"

    if [ -z "$COLOR" ]; then
        PS1="$PYENV_VIRTUALENV_ORIGINAL_PS1"
    else
        PS1="($COLOR${VENV_NAME}$RESET)$PYENV_VIRTUALENV_ORIGINAL_PS1"
    fi
    export PS1
}
export PROMPT_COMMAND="pyenvVirtualenvUpdatePrompt; $PROMPT_COMMAND"

### scm_breeze
[ -s "/Users/folkol/.scm_breeze/scm_breeze.sh" ] && source "/Users/folkol/.scm_breeze/scm_breeze.sh"

#. <(openstack complete)

#### scm_breeze overrides
alias emacs='exec_scmb_expand_args /usr/bin/env emacs'
#complete -o bashdefault -I -F get_era_ticket_initial gc
complete -o bashdefault -F get_era_ticket gc

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
#. "$HOME/.cargo/env"
if [ -f '/Users/folkol/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/folkol/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/opt/google-cloud-sdk/path.bash.inc' ]; then . '/usr/local/opt/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/opt/google-cloud-sdk/completion.bash.inc' ]; then . '/usr/local/opt/google-cloud-sdk/completion.bash.inc'; fi

\which hugo &>/dev/null && . <(hugo completion bash)
