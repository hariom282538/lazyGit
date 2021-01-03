#!/bin/bash

pull() {
    # ------------- Quick Pull -----------------
    if [[ $(git status --porcelain=v1 2>/dev/null | wc -l) -ge 0 ]]; then
        echo "Untracked changes: $(git update-index --refresh)"
        echo "commit[1] or stash[2] changes"
        read -p "Please select an option 1[commit local changes] 2[stash local changes] " cSOption
        case $cSOption in
        1)
            git add .
            git commit --allow-empty -a -m "local_changes_commit"
            return
            ;;
        2)
            git stash push -m "local_changes_stashed"
            return
            ;;
        esac

    else
        echo "select option for pulling new commits from a remote server"
        echo "1. Pull Current Branch $(git rev-parse --abbrev-ref HEAD)"
        echo "2. Pull from Existing Other Branch"
        echo "3. Pull specific commits [cherry-pick commits]"
        read -p "Please select an option " pullOption
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

    fi

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
    read -p "Please select an option " branchOption

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
        read -p "Enter branch name: " newBranch
        git checkout -b $newBranch
        git push -u origin $newBranch
        return
        ;;
    *) echo "Please answer 1, 2 or 3." ;;
    esac

}

cherrypick() {
    # ------------- Quick cherry-pick -----------------
    read -p "Please provide space-seprated commit ids ex. ("34cea36zzz" "18cc3c8zzz" "e8637dfzzz")" commitID
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
    echo "show"
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
            read -p "Wanted to change? [Y/n]" gitConfigChange
            case $gitConfigChange in
            [Yy]*)
                config
                return
                ;;
            [Nn]*)
                return
                ;;
            esac

        else
            echo "No git configuartion on this system"
            config
        fi

        read -p "Push to existing Git Repositary. Repo URL? [ex: git@bitbucket.org:USER/REPO.git]" gitRepo
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
    read -p "Global(system level) or Local(project level)? [G/l]" gitConfigSetup
    case $gitConfigSetup in
    [Gg]*)
        git config --global credential.helper store
        read -p "Enter your git name:  " gitName
        git config --global --add user.name $gitName
        read -p "Enter your git email: " gitEmail
        git config --global --add user.email $gitEmail
        return
        ;;
    [Ll]*)
        git config --local credential.helper store
        read -p "Enter your git name:  " gitName
        git config --local --add user.name $gitName
        read -p "Enter your git email: " gitEmail
        git config --local --add user.email $gitEmail
        return
        ;;
    esac
}

select_from_list() {
    prompt="Please select an item:"

    options=()

    if [ -z "$1" ]; then
        # Get options from PIPE
        input=$(cat /dev/stdin)
        while read -p line; do
            options+=("$line")
        done <<<"$input"
    else
        # Get options from command line
        for var in "$@"; do
            options+=("$var")
        done
    fi

    # Close stdin
    0<&-
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
    while getopts ":uds" opt; do
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
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
        esac
    done
    else
    init
    fi
}
