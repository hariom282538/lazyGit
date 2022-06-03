#!/bin/bash

pull() {
    # ------------- Quick Pull -----------------
    if [[ $(git status --porcelain=v1 2>/dev/null | wc -l) -gt 0 ]]; then
        echo "Untracked changes: $(git update-index --refresh)"
        echo "commit[1] or stash[2] changes"
        printf '%s ' "Please select an option 1[commit local changes] 2[stash local changes] " 
        read cSOption
        case $cSOption in
        1)
            git add .
            printf '%s ' "Please provide your git commit message" 
            read gitcmsg
            git commit --allow-empty -a -m $gitcmsg
            pullRemoteBranch
            ;;
        2)
            printf '%s ' "Please provide your git stash message" 
            read gitcmsg
            git stash push -m $gitcmsg
            pullRemoteBranch
            ;;
        esac

    else
        pullRemoteBranch
    fi

}

pullRemoteBranch() {
    echo "select option for pulling new commits from a remote server"
    echo "1. Pull Current Branch $(git rev-parse --abbrev-ref HEAD)"
    echo "2. Pull from Existing Other Branch"
    echo "3. Pull specific commits [cherry-pick commits]"
    printf '%s ' "Please select an option " 
    read pullOption
    case $pullOption in
    1 | c | C)
        git pull origin $(git rev-parse --abbrev-ref HEAD)
        return
        ;;
    2 | e | E)
        echo "Loading all local and remote branches..."
        local selectedBranch=$(git branch -a | tr -s '*' ' ' | tr -d "[:blank:]" | cut -d/ -f3 | sort -u | select_from_list)
        local STATUS=$?
        # Check if user selected something
        if [ $STATUS == 0 ]; then
            echo "Branch selected by user:" $selectedBranch
            if [[ $selectedBranch=$(git rev-parse --abbrev-ref HEAD) ]]; then
                git pull origin $(git rev-parse --abbrev-ref HEAD)
            else
                git pull origin $selectedBranch
            fi
        else
            echo "Cancelled!"
        fi

        return
        ;;
    3 | cp | CP)
        cherrypick
        return
        ;;
    *) echo "Please answer 1/c/C, 2/e/E or 3/cp/CP." ;;
    esac
}

push() {
    # ------------- Quick Push -----------------
    git add .
    git commit --allow-empty -a -m "$*"
    # give user to select/create branch
    echo "select option for publishing new local commits on a remote server"
    echo "1. Current Branch $(git rev-parse --abbrev-ref HEAD)"
    echo "2. Existing Branch"
    echo "3. New Branch"
    printf '%s ' "Please select an option " 
    read branchOption

    case $branchOption in
    1 | c | C)
        git push -u origin $(git rev-parse --abbrev-ref HEAD)
        return
        ;;
    2 | e | E)
        echo "Loading all local and remote branches..."
        selectedBranch=$(git branch -a | tr -s '*' ' ' | tr -d "[:blank:]" | cut -d/ -f3 | sort -u | select_from_list)
        local STATUS=$?
        # Check if user selected something
        if [ $STATUS == 0 ]; then
            echo "Branch selected by user:" $selectedBranch
            if [[ $selectedBranch=$(git rev-parse --abbrev-ref HEAD) ]]; then
                git push -u origin $(git rev-parse --abbrev-ref HEAD)
            else
                commitedCodeBranch=$(git rev-parse --abbrev-ref HEAD)
                git checkout $selectedBranch
                git merge $commitedCodeBranch
                git push -u origin $selectedBranch
            fi
        else
            echo "Cancelled!"
        fi

        return
        ;;
    3 | n | N)
        printf '%s ' "Enter branch name: " 
        read newBranch
        git checkout -b $newBranch
        git push -u origin $newBranch
        return
        ;;
    *) echo "Please answer 1, 2 or 3." ;;
    esac

}

cherrypick() {
    # ------------- Quick cherry-pick -----------------
    printf '%s ' "Please provide space-seprated commit ids ex. ("34cea36zzz" "18cc3c8zzz" "e8637dfzzz")" 
    read commitID
    declare -a commitsArray=$commitID
    local arraylength=${#commitsArray[@]}
    declare cherryPickBranch=cherryPick-$(git rev-parse --abbrev-ref HEAD)-$(date "+%Y.%m.%d-%H.%M.%S")
    git checkout -b $cherryPickBranch
    # use for loop to read all values of commits
    for ((i = ${arraylength}; i > 0; i--)); do
        echo $i " / " ${arraylength} " : " ${commitsArray[$i - 1]}
        local rawHash=${commitsArray[$i - 1]}
        local hash=${rawHash:0:7}
        printf "cherry picking ${hash} ...\n"
        local read_status=$(git cherry-pick -x "${hash}" 2>&1)
        local empty_message="The previous cherry-pick is now empty"
        local error_message="error: cherry-pick is not possible because you have unmerged files"
        local online_edited="edited online with Bitbucket"
        if [[ $read_status = *"$online_edited"* ]]; then
            echo $read_status
            exit 0
        elif [[ $read_status = *"$error_message"* ]]; then
            echo $read_status
            exit 0
        elif [[ $read_status = *"$empty_message"* ]]; then
            echo yes
            git commit --allow-empty -m "${hash} empty"
        else
            echo no
            if [ $? -eq 0 ]; then
                echo "$hash - cherry-picked"
            else
                echo "There are conflicts to resolve!"
                exit 0
            fi
        fi
    done
    git push -u origin $cherryPickBranch
}

show() {
    selectedCommit=$(git log -n 10 --oneline --pretty="format:%h:%s:%ce:%ci" | select_from_list)
    git diff-tree --no-commit-id --name-only -r $(echo "$selectedCommit" | cut -d: -f1)
}

init() {
    read -p "Initialize the local directory as a Git repository? [Y/n]" gitSetup
    case $gitSetup in
    [Yy]*)
        git init
        if [[ $(git config user.name) ]]; then
            echo "Git configurations found!"
            echo "Configured Git Name: $(git config user.name)"
            echo "Configured Git Email: $(git config user.email)"
            printf '%s '"Wanted to change? [Y/n]" 
            read gitConfigChange
            case $gitConfigChange in
            [Yy]*)
                config
                ;;
            [Nn]*) ;;

            esac

        else
            echo "No git configuartion on this system"
            config
        fi

        printf '%s ' "Push to existing Git Repositary. Repo URL? [ex: git@bitbucket.org:USER/REPO.git]" 
        read gitRepo
        git remote add origin $gitRepo
        git remote -v
        git add .
        git commit --allow-empty -a -m "$*"
        git push -u origin master
        return
        ;;
    [Nn]*) return ;;
    *) echo "Please answer yes or no." ;;
    esac
}

config() {
    printf '%s ' "Global(system level) or Local(project level)? [G/l]" 
    read gitConfigSetup
    case $gitConfigSetup in
    [Gg]*)
        git config --global credential.helper store
        printf '%s ' "Enter your git name:  " 
        read gitName
        git config --global --add user.name $gitName
        printf '%s ' "Enter your git email: " 
        read gitEmail
        git config --global --add user.email $gitEmail
        return
        ;;
    [Ll]*)
        git config --local credential.helper store
        printf '%s ' "Enter your git name:  " 
        read gitName
        git config --local --add user.name $gitName
        printf '%s '"Enter your git email: " 
        read gitEmail
        git config --local --add user.email $gitEmail
        return
        ;;
    esac
}

select_from_list() {
    prompt="Please select an item:"

    local -a options=()

    if [ -z "$1" ]; then
        # Get options from PIPE
        input=$(cat /dev/stdin)

        while read line; do
            options+=("$line")
        done <<<"$input"
    else
        # Get options from command line
        for var in "$@"; do
            options+=("$var")
        done
    fi

    # Close stdin
    # 0<&-

    # open /dev/tty as stdin
    exec 0</dev/tty

    PS3="$prompt "
    select opt in "${options[@]}" "Quit"; do
        if ((REPLY == 1 + ${#options[@]})); then
            exit 1

        elif ((REPLY > 0 && REPLY <= ${#options[@]})); then
            break

        else
            echo "Invalid option. Try another one."
        fi
    done
    echo $opt
}

function lazygit() {
    if [ -d .git ]; then
        declare opt
        declare OPTARG
        declare OPTIND
        while getopts ":u:ds" opt; do
            case $opt in
            d)
                echo "pull was triggered, Parameter: $OPTARG" >&2
                pull
                ;;
            u)
                echo "push was triggered, Parameter: $OPTARG" >&2
                push $OPTARG
                ;;
            s)
                echo "show was triggered, Parameter: $OPTARG" >&2
                show
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 0
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                exit 0
                ;;
            esac
        done
    else
        init $*
    fi
}