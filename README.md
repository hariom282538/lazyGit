LazyGit
======================
[![setup-lazygit](logo.svg)](setup-lazygit)

This is the tool I use for pushing code to git repos. Please take a look! I assume some prior knowledge of Git, but it's not totally required.

#  Why LazyGit!

Add, commit and push, Three mostly used commands by me when I made any change in any file but running these commands every time especially when you're working on multiple projects is completely waste of time. So, I started with a small script comprises these three commands and added more features whenever required. 

## Case-1 Push new project 

```bash
HARIOM-MAC:$ lazygit first_commit_msg
Initialize the local directory as a Git repository? [Y/n]y
Initialized empty Git repository in /Users/b0212006/devops/aws_s3-upload-utility/.git/
Git configurations found!
Configured Git Name: Hariom Vashisth
Configured Git Email: accoun2@gmail.com
Wanted to change? [Y/n]y
Global(system level) or Local(project level)? [G/l]l
Enter your git name:  hariom282538
Enter your git email: account1@gmail.com
Push to existing Git Repositary. Repo URL? [ex: git@bitbucket.org:USER/REPO.git]https://github.com/hariom282538/aws_s3-upload-utility.git
origin  https://github.com/hariom282538/aws_s3-upload-utility.git (fetch)
origin  https://github.com/hariom282538/aws_s3-upload-utility.git (push)
[master (root-commit) beed54a] first_commit_msg
 5 files changed, 365 insertions(+)
 create mode 100644 CODE_OF_CONDUCT.md
 create mode 100644 LICENSE
 create mode 100644 README.md
 create mode 100644 aws-s3-bucket.svg
 create mode 100644 fileUpload.sh
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 4 threads
Compressing objects: 100% (7/7), done.
Writing objects: 100% (7/7), 6.98 KiB | 2.33 MiB/s, done.
Total 7 (delta 0), reused 0 (delta 0)
To https://github.com/hariom282538/aws_s3-upload-utility.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

## Case-2 Update/Push existing project

```bash
HARIOM-MAC:lazyGit HARIOM$ lazygit adding stuff
Global Git configurations found!
Configured Git Name:  hariom282538
[master 41db665] adding stuff
 3 files changed, 48 insertions(+)
 create mode 100644 README.md
 create mode 100644 logo.svg
 create mode 100644 setup.sh
select option for publishing new local commits on a remote server
1. Existing Branch
2. New Branch
Please select an option [1/2]: 1
Loading all local and remote branches...
1) master
2) Quit
Please select an item: 1
Branch selected by user: master
Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 4 threads
Compressing objects: 100% (5/5), done.
Writing objects: 100% (5/5), 4.24 KiB | 2.12 MiB/s, done.
Total 5 (delta 0), reused 0 (delta 0)
To github.com:hariom282538/lazyGit.git
   3280c29..41db665  master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

# How to run

Run this (supports linux/mac only):

```bash
chmod +x setup.sh
./setup.sh
```

##### The purpose of these script is to simplify daily git operations for programmers/DevOps. 

----
Want to contribute? Great!
 - [Connect ->  Hariom Vashisth](mailto:hariom.devops@gmail.com)