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

## Case-2 Push existing project changes to current/other/new branch

```bash
HARIOM-MAC:$ lazygit -u readme_updated
push was triggered, Parameter: readme_updated
[master acec79a] readme_updated
 2 files changed, 30 insertions(+), 17 deletions(-)
select option for publishing new local commits on a remote server
1. Current Branch master
2. Existing Branch
3. New Branch
Please select an option 1
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 4 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 879 bytes | 879.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
To https://github.com/hariom282538/lazyGit.git
   2ebe557..acec79a  master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

## Case-3 Pull existing project changes from current/other/new remote branch

```bash
HARIOM-MAC:lazyGit $ lazygit -d
pull was triggered, Parameter: 
Untracked changes: .lazyGit.sh: needs update
commit[1] or stash[2] changes
Please select an option 1[commit local changes] 2[stash local changes] 1
[master 5cebcfb] local_changes_commit
 1 file changed, 1 insertion(+), 1 deletion(-)
HARIOM-MAC:lazyGit $ lazygit -d
pull was triggered, Parameter: 
select option for pulling new commits from a remote server
1. Pull Current Branch master
2. Pull from Existing Other Branch
3. Pull specific commits [cherry-pick commits]
Please select an option 1
From https://github.com/hariom282538/lazyGit
 * branch            master     -> FETCH_HEAD
Auto-merging README.md
Merge made by the 'recursive' strategy.
 README.md | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
```

# How to run

Run this (linux/mac bash-terminal only):

```bash
chmod +x setup.sh
./setup.sh
```

##### The purpose of these script is to simplify daily git operations for programmers/DevOps. 

----
Want to contribute? Great!
 - [Connect ->  Hariom Vashisth](mailto:hariom.devops@gmail.com)
