#!/bin/bash
set +x

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

_master_or_main() {
  # return default branch
  git branch | grep " master\| main" | tr -d \* | xargs
}

_current_branch() {
  git branch | grep "\*" | cut -d' ' -f2
}

grebase() {
  # check if uncommitted changes exist
  if [[ $(git status --porcelain) != "" ]]; then
    echo "${RED}You have uncommitted changes. Please commit or stash them before running this command.${NC}"
    return
  fi
  rebase_branch=$(gb)
  current_branch=$(_current_branch)
  # if current branch is master do nothing
  if [[ $current_branch == "$rebase_branch" ]]; then
    return
  fi
  git rebase -i "$rebase_branch"
}

gcom() {
  default=$(_master_or_main)
  git checkout "$default"
}

gnew() {
  # make a new branch prefixed with evan/
  # convert all arguments to dash-separated string
  branch_name=$(echo "$@" | tr ' ' '-')
  git checkout -b "evan/$branch_name"
}

gcane() {
  git add .
  git commit --amend --no-edit
}

is_in_git_repo() {
  git rev-parse HEAD >/dev/null 2>&1
}

fzf-down() {
  fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
}

gco() {
  branch=$(gb --prompt 'Checkout git branch')
  # check for -d flag
  if [[ $* == *-d* ]]; then
    echo "Deleting branch ${branch}"
    confirm=$(echo "Cancel\nConfirm" | fzf-down --prompt "Delete branch ${branch}?")
    if [[ $confirm == 'Confirm' ]]; then
      git branch -D "$branch"
    fi
    return
  fi
  git checkout "$branch"
}
