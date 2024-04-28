# Leave my ^S alone!
# if tty -s; then
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
    stty stop undef 2>/dev/null
    stty start undef 2>/dev/null
fi
# fi

### HISTORY COMMANDS

shopt -s histappend
#shopt -s globstar
PROMPT_COMMAND="history -n; history -a; $PROMPT_COMMAND"
export HISTCONTROL=ignoreboth
export HISTFILESIZE=
export HISTSIZE=9999999
export CLICOLOR=Hxxxbxxxxxx
export HISTTIMEFORMAT="%d/%m/%y %T "

### PATH

#export PATH=$(brew --prefix openssl)/bin:$PATH
#export PATH="/usr/local/opt/openssl:$PATH"
#export PATH="/usr/local/opt/openssl/bin:$PATH"
#export PATH=$PATH:/Users/folkol/bin/scripts:/Users/folkol/bin/polopoly:/Users/folkol/bin
#export PATH=/usr/bin/wget:/usr/local/apache-maven/apache-maven-2.2.1/bin/mvn:/usr/local/sbin:$PATH
#export PATH=$PATH:/Applications/JD-GUI.app/Contents/MacOS
#export PATH=/usr/local/bin:$PATH
#export PATH="/Users/folkol/code/ace/system-tests/test-scripts/bin:$PATH"
#export PATH="$PATH:/Users/folkol/Library/Python/2.7/bin"
export PATH="$PATH:/Users/folkol/code/futils/bin"
#export PATH="/usr/local/opt/flex/bin:$PATH"
#export PATH="/usr/local/opt/texinfo/bin/:$PATH"
#export PATH="/Users/folkol/code/futils/bin:$PATH"
#export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/Users/folkol/bin:/Users/folkol/bin/scripts:$PATH"
#export PATH="/usr/local/opt/gettext/bin:$PATH"
#export PATH="$HOME/Library/Python/3.7/bin/:$PATH"
#export PATH="$HOME/Library/Python/3.6/bin/:$PATH"
#export PATH="$PATH:~/.tacit"
export PATH="$PATH:/opt/homebrew/bin/"
#export PATH="/Users/folkol/go/go1.19.1/bin:$PATH"
export NPM_TOKEN=
export PATH="$PATH:/Users/folkol/code/apl-inspired-filters/target/release/"

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

accs ()
{
    local DB=/Users/folkol/code/funnel-io/panther-analysis/lookup_tables/aws_accounts/aws_accounts_data.csv
    if [ "$#" -eq 0 ]; then
        fzf < "$DB"
    else
        for acc in "$@"
        do
            grep "$acc" "$DB"
        done
    fi
}

notes() {
	if [ $# -eq 0 ]; then
		tail -n 20 ~/Documents/notes/main.md
	else
		rg -C5 "$@" ~/Documents/notes/
	fi
}

aws-regions() {
cat <<HERE
us-east-2	US East (Ohio)
us-east-1	US East (N. Virginia)
us-west-1	US West (N. California)
us-west-2	US West (Oregon)
af-south-1	Africa (Cape Town)
ap-east-1	Asia Pacific (Hong Kong)
ap-south-2	Asia Pacific (Hyderabad)
ap-southeast-3	Asia Pacific (Jakarta)
ap-southeast-4	Asia Pacific (Melbourne)
ap-south-1	Asia Pacific (Mumbai)
ap-northeast-3	Asia Pacific (Osaka)
ap-northeast-2	Asia Pacific (Seoul)
ap-southeast-1	Asia Pacific (Singapore)
ap-southeast-2	Asia Pacific (Sydney)
ap-northeast-1	Asia Pacific (Tokyo)
ca-central-1	Canada (Central)
eu-central-1	Europe (Frankfurt)
eu-west-1	Europe (Ireland)
eu-west-2	Europe (London)
eu-south-1	Europe (Milan)
eu-west-3	Europe (Paris)
eu-south-2	Europe (Spain)
eu-north-1	Europe (Stockholm)
eu-central-2	Europe (Zurich)
il-central-1	Israel (Tel Aviv)
me-south-1	Middle East (Bahrain)
me-central-1	Middle East (UAE)
sa-east-1	South America (São Paulo)
HERE
}

funnel_apps() {
	echo "8007: MELD API"
	echo "8028: PRICING APP"
}

hist ()
{
    sort -n | uniq -c | while read -r COUNT ITEM; do
        printf "$ITEM: %${COUNT}s\n" | tr ' ' '*';
    done
}

mansect () {
    # from man man
    cat <<HERE
The sections of the manual are:
 1.   General Commands Manual
 2.   System Calls Manual
 3.   Library Functions Manual
 4.   Kernel Interfaces Manual
 5.   File Formats Manual
 6.   Games Manual
 7.   Miscellaneous Information Manual
 8.   System Manager's Manual
 9.   Kernel Developer's Manual
HERE
}

mangrep ()
{
    if [ $# -eq 0 ]; then
        echo 'usage: [GMAN_OPTS="..."] mangrep pattern' >&2
        return 1
    fi
    # requires `man2ascii` = `mandoc -Tascii` on PATH
    # invoke with GMAN_OPTS=... if you want to pass additional opts to man, such as -S 1
    gman --where $GMAN_OPTS --manpath "$(manpath)" --global-apropos "$@" | xargs rg -C3 --pre 'man2ascii' "$@"
}

marketing-acronyms() {
    cat <<HERE
    from https://cydigitalmarketing.com/what-does-ppc-cpa-cpc-cpm-ctr-ppi-and-cpi-actually-mean/
CPM (Cost Per Mile/Thousand)
A confusing one this as many assume it means cost per million, when in actual fact it means cost per thousand or mile (another term), the amount is based on impressions and the base unit is one thousand.

PPC (Pay Per Click)
Pay Per Click (PPC) and Cost Per Click (CPC) are one and the same in all honesty, the point is you are paying for a click on an advert, and the publisher gets paid for the click, simple.

CPC (Cost Per Click)
As a publisher the CPC (cost per click) is the amount of revenue that you earn each time a visitor clicks an ad displayed on your blog, website, or article. The advertiser determines how much the CPC for any ad will be.

CTR (Click Through Rate)
Your CTR (click through rate) will be a sign of the success of your online advertising program or campaign as it will show you how many clicks you are obtaining for impression served.

eCPM (Effective Cost Per Thousand Impressions)
if you are an advertiser you can use eCPM to work out how much it will cost to have an ad placed on a particular website, this can be helpful if you have a limited budget but really like one publisher and want to be seen on their website with your advert.

CPI (Cost Per Impression)
A CPI or cost per impression is a price paid for an impression paid to a website owner (publisher) or a network offering placement in search results or on websites.

PPI (Pay Per Impression)
Similar to CPC and PPC, Pay Per Impression (PPI) and Cost Per Impression (CPI) are used to mean the same thing by different people.

CPA/CPL/CPS (Cost Per Action/Acquisition/Lead/Sale)
People use many choices for metrics in this area such as a sign up to a newsletter (CPA), an actual sale (CPS) or similar and the terms used will primarily depend on what the action is primarily.

VTR (View Through Rate)
VTR or (view through rate) is a way of measuring the actual number of post-impression views or responses or ‘view-throughs’ from and sort of display media impressions viewed during and following an online advertising campaign.
HERE
}

json-structure() {
    jq '[path(..)|map(if type=="number" then "[]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]'
}

source-type-teams ()
{
    (
        echo 'adjust¤Bananalytics'
        cd /Users/folkol/code/funnel-io/connector-plugins/plugins
        paste -d '¤' <(basename -s .json */source_type_configs/*.json) <(jq -r .info.team */source_type_configs/*.json)
    ) | column -t -s '¤'
}

get_fb ()
{
    [ -z "$TOKEN" ] && {
        echo 'Missing $TOKEN' 1>&2;
        return 1
    };
    curl "https://funnel.firebaseio.com/${1}.json?auth=$TOKEN"
}

list-accounts () {
    aws-vault exec qwaya -- aws organizations list-accounts --query 'Accounts[*][Id, Name]' --output=text
}

aws-logs ()
{
    local group=$1;
    if [ -z "$group" ]; then
        group=$(aws logs describe-log-groups | jq -r '.logGroups[].logGroupName' | fzf);
    fi;
    aws logs tail --since 1h --follow "$group"
}

function vx() {
    local NPM_TOKEN=$(
        aws-vault exec qwaya -- \
            aws secretsmanager get-secret-value \
                --region eu-west-1 \
                --secret-id arn:aws:secretsmanager:eu-west-1:489064650666:secret:npm-readonly-token-AHaomK \
                --output text \
                --query SecretString)
    NPM_TOKEN=$NPM_TOKEN aws-vault exec ${ACCOUNT:-qwaya} -- ${@:-echo something works}
}

function operator-presedence-javascript() {
    # https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Operator_Precedence
    # https://www.calculateme.com/text/html-table-to-text

    echo 'left-associative, except for exponentiation, assignment and ternary'
    echo '( )'
    echo '. [] ?. ()'
    echo 'x++ x--'
    echo '! ~ + - ++x --x typeof void delete await'
    echo '**'
    echo '* / %'
    echo '+ -'
    echo '<< >> >>>'
    echo '< <= > >= in instancaeof'
    echo '== != === !=='
    echo '&'
    echo '^'
    echo '|'
    echo '&&'
    echo '|| ??'
    echo '= op= ?: => yield yield* ...'
    echo ','
}


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

function todos() {
    echo '=== explicit todos ==='
    sed 's/^/- /' ~/Documents/notes/todos
    echo
    echo '=== found in notes ==='
    rg TODO ~/Documents/notes
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
    git log "${1:-origin/main}" --reverse --pretty=format:%h $2 \
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

# urldecode() {
#     local url_encoded="${1//+/ }"
#     printf '%b' "${url_encoded//%/\\x}"
# }

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
    for ref in $(git for-each-ref --count=20 --sort=-committerdate refs/remotes/ --format='%(refname:short)'); do
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

# drop() {
#     local num_rows=${1:-1}
#     tail -n +$(($num_rows + 1))
# }

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

# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
for file in /usr/local/etc/bash_completion.d/* /opt/homebrew/etc/bash_completion.d/*; do
    source $file
done 2>/dev/null

complete_it() { COMPREPLY=( $(itermocil --list | grep '^ ') ); }
complete -F complete_it it

complete_aws_vault() { COMPREPLY=($(aws configure list-profiles)); }
complete -F complete_aws_vault aws-vault
complete -F complete_aws_vault av

for file in /opt/homebrew/etc/bash_completion.d/*; do
    source $file
done 2>/dev/null

### ALIASES
alias fzfp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias stripansi="sed -e 's/\x1b\[[0-9;]*m//g'"
alias git-mob-all='git mob vt tb pa'
alias funnel-urls='(cd /Users/folkol/code/funnel-io && rg -I -o "https?://[a-zA-Z0-9.-]+\.funnel.io" | sort -u)'
alias cutt='cut -c-$COLUMNS'
alias uuid=uuidgen
alias asciibanner=figlet
alias json_paths="jq -r 'leaf_paths | join(\"/\")'"
alias av=aws-vault
alias it=itermocil
alias histogram='sort | uniq -c | sort -rn'
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
# alias pcat=pygmentize
alias passphrase='gshuf /usr/share/dict/words | head -n 3 | tr "\n" " "'
#alias todo='gg todo'
alias jp='jupyter notebook'
alias vb='vim ~/.bash_profile'
alias gcom='git checkout master || git checkout main'
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
alias gdm='git diff origin/master || git diff origin/main'
alias gmm='git merge origin/master || git merge origin/main'
alias gg='git grep -iEI'
alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias funiq="awk '!seen[\$0]++'"
alias mkpasswd='openssl rand -base64 48'
alias v='test -d venv || python3 -m venv venv && . venv/bin/activate'
alias m='cd ~/code/mota'
alias s='cd /Users/folkol/code/soda/ansible'
alias i='cd ~/ivbar'
alias t='tree --gitfile ~/.gitignore_global --gitignore -L 3'
alias l=ll
alias kafka-offset="docker exec -it ace.kafka /bin/sh -c '/opt/kafka*/bin//kafka-run-class.sh kafka.tools.GetOffsetShell --topic polopoly.changelist --broker-list localhost:9092' | cut -d: -f3"
alias dockershell='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
alias git-diff-ignore-whitespace='git diff --word-diff-regex=[^[:space:]]'
alias docker-kill-all='docker ps -qa | each "docker stop" "docker rm"'
alias docker-stats-names='docker stats `docker ps --format "{{.Names}}"`'
alias serve='python3 -m http.server'
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
# export PATH=/opt/local/bin:/opt/local/sbin:$PATH
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
# PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
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

PATH="$PATH:/Users/folkol/.cargo/bin"
PATH="$PATH:$HOME/.cargo/bin"

unset PROMPT_COMMAND

c() {
    cd "/Users/folkol/code/$({ echo .; ls ~/code; } | fzf)"
}
