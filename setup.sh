#!/bin/bash

linuxSetup() {
    cp .lazyGit.sh ~/
    echo 'source ~/.lazyGit.sh' >>~/.bashrc
    source ~/.bashrc
}

macSetup() {
    cp .lazyGit.sh ~/
    echo 'source ~/.lazyGit.sh' >>~/.bash_profile
    source ~/.bash_profile
}

# Ask the user for their os
echo welcome, $USER
echo what\'s your operating system?
echo 1. Linux
echo 2. Mac
read os
if [[ $os == "1" || $os == "linux" ]]; then
    linuxSetup
elif [[ $os == "2" || $os == "mac" ]]; then
    macSetup
else
    echo wrong input!

fi
