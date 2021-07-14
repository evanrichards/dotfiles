GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# git checkout branch
function gco() {
    # no args, list branches with numbers
    if [[ $# -eq 0 ]]; then
        branches=$(git branch)
        counter=1
        echo $branches | while read b; do
            # if branch is not master, show number
            if [[ $b != *"master" ]]; then
                echo "${GREEN}$counter${NC}: $b" | tr -d \* | xargs
                ((counter++))
            fi
        done
    else
        # switch to numbered branch
        branches=$(git branch)
        counter=1
        echo $branches | while read b; do
            branch=$(echo $b | tr -d \* | xargs)
            if [[ $1 -eq $counter ]]; then
                git checkout $branch
            fi
            ((counter++))
        done
    fi
}

function grebase() {
    current_branch=$(git branch | grep \* | cut -d' ' -f2)
    # if current branch is master do nothing
    if [[ $current_branch == "master" ]]; then
        return
    fi
    git checkout master
    git pull
    git checkout $current_branch
    git rebase master
    return $?
}

function gcom() {
    git checkout master
}

function gdiff() {
    # check if uncommitted changes exist
    if [[ $(git status --porcelain) != "" ]]; then
        echo "${RED}You have uncommitted changes. Please commit or stash them before running this command.${NC}"
        return
    fi
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
    # good to diff
    # get commit title
    commit_title=$(git log --pretty=format:"%s" -n 1)
    # get branch name
    branch_name=$(git branch | grep \* | cut -d' ' -f2)
    # get repository name
    repository_name=$(git remote -v | grep push | cut -d'/' -f6 | cut -d' ' -f1)
    git push $force origin $branch_name
    if [[ $? -ne 0 ]]; then
        echo "${RED}There was an error pushing to the remote repository. Please resolve the error and try again.${NC}"
        return
    fi
    # get timestamp
    timestamp=$(date +%Y-%m-%d_%H-%M-%S)
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
