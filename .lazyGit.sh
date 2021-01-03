#!/bin/bash

pull() {
    if [[ $(git status --porcelain=v1 2>/dev/null | wc -l) ]]; then
        echo "Untracked changes: $(git update-index --refresh)"
        echo "commit or stash changes"
    else
        echo "go and pull changeas"
        echo "select option for publishing new local commits on a remote server"
        echo "1. Pull Current Branch $(git rev-parse --abbrev-ref HEAD)"
        echo "2. Pull from Existing Other Branch"
        echo "3. Pull specific commits [cherry-pick commits]"
        read -p "Please select an option " pullOption
    fi

}

push() {
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
                git push -U origin $selectedBranch
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
    echo "cherrypick"

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
            push
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
}
