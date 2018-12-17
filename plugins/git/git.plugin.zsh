# Query/use custom command for `git`.
zstyle -s ":vcs_info:git:*:-all-" "command" _omz_git_git_cmd
: ${_omz_git_git_cmd:=git}

#
# Functions
#

# The name of the current branch
# Back-compatibility wrapper for when this function was defined here in
# the plugin, before being pulled in to core lib/git.zsh as git_current_branch()
# to fix the core -> git plugin dependency.
function current_branch() {
  git_current_branch
}
# The list of remotes
function current_repository() {
  if ! $_omz_git_git_cmd rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi
  echo $($_omz_git_git_cmd remote -v | cut -d':' -f 2)
}
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

function gds () {
        CUR_DIR="$(pwd)"
        echo; echo; echo "Wolf:"
        wolf
        git status
        echo; echo "-------------------------------------------"; echo; echo
        echo; echo "Shire:"
        shire
        git status
        cd $CUR_DIR
        echo; echo; echo
}

function gap () {
    git add -p
    if [ $? -ne 0 ]; then
            echo "Didn't complete \`git add -p\`; exiting."
            exit 0
    fi
    echo "Enter commit message (remember to hit enter after last line; ctrl+c then ctrl+d to exit):"
    MESSAGE=$(</dev/stdin)
    git commit -m "$MESSAGE"
    if [ $? -eq 0 ]; then
        echo Success!
    else
        echo FAIL
    fi
    echo \
}

#FROM BASH vvv
alias gaa="git add ."
# see script for gac: adds/commits and writes message for $1
alias gb="git branch"
alias gbs="git branch --sort=-committerdate"
alias gc="git checkout $1"
alias gc-="git checkout -"
alias gct-="git checkout trevor"
alias gd="git diff"
alias gdl="git diff --unified=10" # show more lines (10) around diffs to provide deeper context
alias gdh="git diff HEAD~1"
alias gfa='git fetch --all'
alias gdn="git diff --name-only"
alias gl="git log"
alias gll="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

alias gs="git status"
#alias g212="git checkout 2.1.2"
alias g22="git checkout 2.2.0"
alias g221="git checkout 2.2.1"
alias g223="git checkout 2.2.3"
alias g224="git checkout 2.2.4"
alias g225="git checkout 2.2.5"
alias g226="git checkout 2.2.6"
alias g224h="git checkout 2.2.4-bike-hotfix"
alias g230="git checkout 2.3.0-phone"
alias g240="git checkout 2.4.0-rower || (git fetch --all && git checkout 2.4.0-rower)"
alias g231="git checkout 2.3.1"
#alias gs212="git checkout wolf-2.1.2"
alias gs22="git checkout wolf-2.2.0"
alias gs221="git checkout wolf-2.2.1"
alias gs223="git checkout wolf-2.2.3"
alias gs224="git checkout wolf-2.2.4"
alias gs225="git checkout wolf-2.2.5"
alias gs226="git checkout wolf-2.2.6"
alias gs224h="git checkout wolf-2.2.4-bike-hotfix"
alias gs230="git checkout wolf-2.3.0"
alias gs231="git checkout wolf-2.3.1"
alias gs240="git checkout wolf-2.4.0 || (git fetch --all && git checkout wolf-2.4.0)"
alias gcb="git checkout -b $1"
alias gcd="git checkout dev"
alias gcm="git checkout master"
alias gct="git checkout test"
alias gits='git status'
alias gpo2="git pull origin 2.0.1"
alias gp21="git pull origin 2.1.0"
alias gp211="git pull origin 2.1.1"
alias gp212="git pull origin 2.1.2"
alias gps212="git pull origin wolf-2.1.2"
alias gpod="git pull origin dev"
alias gpom="git pull origin master"
alias gpot="git pull origin trevor"
alias gpo="git pull origin $1"
alias gpu="git push origin $1"
alias gput="git push origin trevor"
alias gitsu="git submodule update --init --recursive"
alias gpitsu="git pull; git submodule update --init --recursive"
alias gptisu="git pull; git submodule update --init --recursive"
alias gitb="git branch"
alias gm="git mergetool"
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias grh="git reset --hard"
alias grs="git rebase --skip"
#alias gss="git stash save"
#alias gsa="git stash apply stash@{`$1`}"
alias gss="git stash show -p stash@{$"$1"}"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gtl='cd $(git rev-parse --show-toplevel || echo ".")' # go to top level
alias gpro="git pull --rebase origin $1"

function strev {
  if git pull origin trevor; then
    git push origin trevor
  fi
}

function shire () {
    echo "changing to shire"
    cd ${PWD%/wolf*}/wolf/shire
    echo "changed to shire"
    pwd
}

function wolf () {
    echo "changing to wolf"
    cd ${PWD%/wolf*}/wolf
    echo "changed to wolf"
    pwd
}

function reset_it () {
        if [ $# -lt 1 ]; then
                echo "reset_it: too few arguments"
                exit 1
        fi
        THE_DIR=$1
        cd $THE_DIR
        echo "`pwd` exists"
        git reset --hard
}

function reset_all () {
    CUR_DIR="$(pwd)"
    shire
    if [ -d Analytics.Xamarin ]; then
            reset_it Analytics.Xamarin
    fi
    shire
    if [ -d ModernHttpClient ]; then
            reset_it ModernHttpClient
    fi
    wolf
    if [ -d Analytics.Xamarin ]; then
            reset_it Analytics.Xamarin
    fi
    wolf
    if [ -d ModernHttpClient ]; then
            reset_it ModernHttpClient
    fi
    cd $CUR_DIR
    echo "done"
}

#function resetall () {
#    shire
#    if [ -d Analytics.Xamarin ]; then
#            echo Analytics.Xamarin exists
#            cd Analytics.Xamarin
#            echo resetting Analytics.Xamarin
#            git reset --hard
#    fi
#    if [ -d ModernHttpClient ]; then
#            echo  ModernHttpClient exists
#            cd ModernHttpClient
#            echo resetting ModernHttpClient
#            git reset --hard
#    fi
#    wolf
#    if [ -d ModernHttpClient ]; then
#            echo  ModernHttpClient exists
#            cd ModernHttpClient
#            echo resetting ModernHttpClient
#            git reset --hard
#    fi
#    wolf
#    echo "done"
#}

#
# Aliases
# (sorted alphabetically)
#

#alias g='git'

#alias ga='git add'
#alias gaa='git add --all'
#alias gapa='git add --patch'

#alias gb='git branch'
#alias gba='git branch -a'
#alias gbd='git branch -d'
#alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
#alias gbl='git blame -b -w'
#alias gbnm='git branch --no-merged'
#alias gbr='git branch --remote'
#alias gbs='git bisect'
#alias gbsb='git bisect bad'
#alias gbsg='git bisect good'
#alias gbsr='git bisect reset'
#alias gbss='git bisect start'

#alias gc='git commit -v'
#alias gc!='git commit -v --amend'
#alias gcn!='git commit -v --no-edit --amend'
#alias gca='git commit -v -a'
#alias gca!='git commit -v -a --amend'
#alias gcan!='git commit -v -a --no-edit --amend'
#alias gcans!='git commit -v -a -s --no-edit --amend'
#alias gcam='git commit -a -m'
#alias gcsm='git commit -s -m'
#alias gcb='git checkout -b'
#alias gcf='git config --list'
#alias gcl='git clone --recursive'
#alias gclean='git clean -fd'
#alias gpristine='git reset --hard && git clean -dfx'
#alias gcm='git checkout master'
#alias gcd='git checkout develop'
#alias gcmsg='git commit -m'
#alias gco='git checkout'
#alias gcount='git shortlog -sn'
compdef _git gcount
#alias gcp='git cherry-pick'
#alias gcpa='git cherry-pick --abort'
#alias gcpc='git cherry-pick --continue'
#alias gcs='git commit -S'

#alias gd='git diff'
#alias gdca='git diff --cached'
#alias gdct='git describe --tags `git rev-list --tags --max-count=1`'
#alias gdt='git diff-tree --no-commit-id --name-only -r'
#alias gdw='git diff --word-diff'

gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff

#alias gf='git fetch'
#alias gfa='git fetch --all --prune'
#alias gfo='git fetch origin'

function gfg() { git ls-files | grep $@ }
compdef _grep gfg

#alias gg='git gui citool'
#alias gga='git gui citool --amend'

ggf() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force origin "${b:=$1}"
}
compdef _git ggf=git-checkout

ggl() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git pull origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git pull origin "${b:=$1}"
  fi
}
compdef _git ggl=git-checkout

ggp() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git push origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git push origin "${b:=$1}"
  fi
}
compdef _git ggp=git-checkout

ggpnp() {
  if [[ "$#" == 0 ]]; then
    ggl && ggp
  else
    ggl "${*}" && ggp "${*}"
  fi
}
compdef _git ggpnp=git-checkout

ggu() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout

#alias ggpur='ggu'
compdef _git ggpur=git-checkout

#alias ggpull='git pull origin $(git_current_branch)'
compdef _git ggpull=git-checkout

#alias ggpush='git push origin $(git_current_branch)'
compdef _git ggpush=git-checkout

#alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
#alias gpsup='git push --set-upstream origin $(git_current_branch)'

#alias ghh='git help'

#alias gignore='git update-index --assume-unchanged'
#alias gignored='git ls-files -v | grep "^[[:lower:]]"'
#alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef _git git-svn-dcommit-push=git

#alias gk='\gitk --all --branches'
compdef _git gk='gitk'
#alias gke='\gitk --all $(git log -g --pretty=%h)'
compdef _git gke='gitk'

#alias gl='git pull'
#alias glg='git log --stat'
#alias glgp='git log --stat -p'
#alias glgg='git log --graph'
#alias glgga='git log --graph --decorate --all'
#alias glgm='git log --graph --max-count=10'
#alias glo='git log --oneline --decorate'
#alias glol="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
#alias glola="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
#alias glog='git log --oneline --decorate --graph'
#alias gloga='git log --oneline --decorate --graph --all'
#alias glp="_git_log_prettily"
compdef _git glp=git-log

#alias gm='git merge'
#alias gmom='git merge origin/master'
#alias gmt='git mergetool --no-prompt'
#alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
#alias gmum='git merge upstream/master'

#alias gp='git push'
#alias gpd='git push --dry-run'
#alias gpoat='git push origin --all && git push origin --tags'
compdef _git gpoat=git-push
#alias gpu='git push upstream'
#alias gpv='git push -v'

#alias gr='git remote'
#alias gra='git remote add'
#alias grb='git rebase'
#alias grba='git rebase --abort'
#alias grbc='git rebase --continue'
#alias grbi='git rebase -i'
#alias grbm='git rebase master'
#alias grbs='git rebase --skip'
#alias grh='git reset HEAD'
#alias grhh='git reset HEAD --hard'
#alias grmv='git remote rename'
#alias grrm='git remote remove'
#alias grset='git remote set-url'
#alias gru='git reset --'
#alias grup='git remote update'
#alias grv='git remote -v'

#alias gsb='git status -sb'
#alias gsd='git svn dcommit'
#alias gsi='git submodule init'
#alias gsps='git show --pretty=short --show-signature'
#alias gsr='git svn rebase'
#alias gss='git status -s'
#alias gst='git status'
#alias gsta='git stash save'
#alias gstaa='git stash apply'
#alias gstc='git stash clear'
#alias gstd='git stash drop'
#alias gstl='git stash list'
#alias gstp='git stash pop'
#alias gsts='git stash show --text'
#alias gsu='git submodule update'

#alias gts='git tag -s'
#alias gtv='git tag | sort -V'

#alias gunignore='git update-index --no-assume-unchanged'
#alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
#alias gup='git pull --rebase'
#alias gupv='git pull --rebase -v'
#alias glum='git pull upstream master'

#alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
#alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip--"'
