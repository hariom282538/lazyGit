#!/bin/bash

function lazygit() {
    if [ -d .git ]; then
        if [[ $(git config user.name) ]]; then
            echo "Global Git configurations found!"
            # show user details
            echo "Configured Git Name: " $(git config user.name)
        else
            echo "No global git configuartion found on this system"
            # steps for adding user details
            git config --global credential.helper store
            read -r "Enter your git name:  " gitName
            git config --global --add user.name $gitName
            read -r "Enter your git email: " gitEmail
            git config --global --add user.email $gitEmail
        fi
        git add .
        git commit --allow-empty -a -m "$*"
        # give user to select/create branch
        echo "select option for publishing new local commits on a remote server"
        echo "1. Current Branch $(git rev-parse --abbrev-ref HEAD)"
        echo "2. Existing Branch"
        echo "3. New Branch"
        read -r "Please select an option " branchOption
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
                    git push origin $selectedBranch
                fi
            else
                echo "Cancelled!"
            fi

            return
            ;;
        3 | n | N)
            read -r "Enter branch name: " newBranch
            git checkout -b $newBranch
            git push -u origin $newBranch
            return
            ;;
        *) echo "Please answer 1, 2 or 3." ;;
        esac

    else

        read -r "Initialize the local directory as a Git repository? [Y/n]" gitSetup
        case $gitSetup in
        [Yy]*)
            git init
            if [[ $(git config user.name) ]]; then
                echo "Global Git configurations found!"
                # show them user details
                echo "Configured Git Name: " $(git config user.name)
            else
                echo "No gobal git configuartion on this system"
                # steps for adding user details
                git config --global credential.helper store
                read -r "Enter your git name:  " gitName
                git config --global --add user.name $gitName
                read -r "Enter your git email: " gitEmail
                git config --global --add user.email $gitEmail
            fi

            read -r "Push to existing Git Repositary. Repo URL? [ex: git@bitbucket.org:USER/REPO.git]" gitRepo
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
    fi
}

select_from_list() {
    prompt="Please select an item:"

    options=()

    if [ -z "$1" ]; then
        # Get options from PIPE
        input=$(cat /dev/stdin)
        while read -r line; do
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
