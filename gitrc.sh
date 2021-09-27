set +x

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color


# git checkout branch
function gco() {
    # check for -d flag
    delete_branch=false
    if [[ $* == *-d* ]] ; then
        delete_branch=true
        echo "Deleting branch"
        shift
    fi
    echo "$*"
    # no args, list branches with numbers
    default=$(_master_or_main)
    current=$(_current_branch)
    branches=$(git branch)
    unstaged=""
    if [[ $(git status --porcelain) != "" ]]; then
        unstaged=" (${RED}unstaged changes${NC})"
    fi
    if [[ $# -eq 0 ]]; then
        counter=1
        current_marker=""
        if [[ "$branches" == *"* $default"* ]]; then
            current_marker=" (${RED}current${NC})${unstaged}"
        fi
        echo "${GREEN}0${NC}: $default$current_marker"
        echo $branches | while read b; do
            # if branch is not master or main, show number
            if [[ $b != *$default* ]]; then
                current_marker=""
                if [[ $b == *"*"* ]]; then
                    current_marker=" (${RED}current${NC})${unstaged}"
                fi
                echo "${GREEN}$counter${NC}: $b$current_marker" | tr -d \* | xargs
                ((counter++))
            fi
        done

        echo -n "Choose branch: "
        read branchNum
    else
        branchNum=$1
    fi
    counter=1
    if [[ $branchNum == 0 ]]; then
        git checkout $default
        return
    fi
    echo $branches | while read b; do
        if [[ $b != *$default* ]]; then
            if [[ $branchNum -eq $counter ]]; then
                if [[ $delete_branch == true ]]; then
                    # if this branch is the current branch exit without deleting
                    if [[ $b == *"*"* ]]; then
                        echo "${RED}Cannot delete current branch${NC}"
                        return
                    fi
                    echo "Delete branch ${RED}${b}${NC}?"
                    select yn in "Yes" "No"; do
                        case $yn in
                            Yes ) git branch -D $b; break;;
                            No ) break;;
                        esac
                    done
                else
                    git checkout $(echo $b | tr -d \* | xargs)
                fi
                break
            fi
            ((counter++))
        fi
    done
}

function _master_or_main() {
    # return default branch
    git branch | grep "master\|main" | tr -d \* | xargs
}

function _current_branch() {
    git branch | grep \* | cut -d' ' -f2
}

function grebase() {
    # check if uncommitted changes exist
    if [[ $(git status --porcelain) != "" ]]; then
        echo "${RED}You have uncommitted changes. Please commit or stash them before running this command.${NC}"
        return
    fi
    default=$(_master_or_main)
    current_branch=$(_current_branch)
    # if current branch is master do nothing
    if [[ $current_branch == $default ]]; then
        return
    fi
    git checkout $default
    git pull origin $default
    git checkout $current_branch
    git rebase $default
    return $?
}

function gcom() {
    default=$(_master_or_main)
    git checkout $default
}

function gdiff() {
    grebase
    if [[ $? -ne 0 ]]; then
        echo "${RED}There are merge conflicts. Please resolve them before running this command.${NC}"
        return
    fi
    force=""
    # if -f flag is provided, force the diff
    if [[ $1 == "-f" ]]; then
        force="-f"
    fi  
    # get timestamp
    timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    # good to diff
    # get commit title
    commit_title=$(git log --pretty=format:"%s" -n 1)
    # get branch name
    branch_name=$(git branch | grep \* | cut -d' ' -f2)
    # get repository name
    repository_name=$(git remote -v | grep push | cut -d'/' -f6 | cut -d' ' -f1)
    git diff $(_master_or_main) > /tmp/diff_$repository_name_$branch_name_$timestamp.diff
    code /tmp/diff_$repository_name_$branch_name_$timestamp.diff
    # ask for confirmation
    echo "Do you want to commit this diff?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) break;;
            No ) return;;
        esac
    done
    git push $force origin $branch_name
    if [[ $? -ne 0 ]]; then
        echo "${RED}There was an error pushing to the remote repository. Please resolve the error and try again.${NC}"
        return
    fi
    # create aws codecommit pull request
    echo "Creating pull request for ${GREEN} $branch_name ${NC}: ${GREEN}$commit_title${NC}"
    aws codecommit create-pull-request \
        --title "$commit_title" \
        --targets repositoryName=$repository_name,sourceReference=$branch_name >/tmp/pull_request_$timestamp.json
    # if succesful, open browser
    if [[ $? -eq 0 ]]; then
        echo "${GREEN}Pull request created.${NC}"
        # get pull request id
        pull_request_id=$(jq -r .pullRequest.pullRequestId </tmp/pull_request_$timestamp.json)
        # open browser
        link=https://us-west-2.console.aws.amazon.com/codesuite/codecommit/repositories/qualli-app/pull-requests/$pull_request_id/details?region=us-west-2
        echo "Opening browser to pull request... $link"
        open $link
    else
        echo "${RED}Pull request creation failed.${NC}"
        cat /tmp/pull_request_$timestamp.json
    fi
}
