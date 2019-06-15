# LazyGit
======================
[![setup-lazygit](logo.svg)](setup-lazygit)

This is the tool I use for pushing code to git repos. Please take a look! I assume some prior knowledge of Git, but it's not totally required.

#  Why LazyGit!

Add, commit and push, Three mostly used commands by me when I made any change in any file but running these commands every time especially when you're working on multiple projects is completely waste of time. So, I started with a small script comprises these three commands and added more features whenever required. 

Case-1 New 

```bash
HARIOM-MAC:lazyGit HARIOM$ lazygit init
Initialize the local directory as a Git repository? [Y/n]y
Initialized empty Git repository in /Users/HARIOM/devops/lazyGit/.git/
Global Git configurations found!
Configured Git Name:  hariom282538
Push to existing Git Repositary. Repo URL? [ex: git@bitbucket.org:USER/REPO.git]git@github.com:hariom282538/lazyGit.git
origin	git@github.com:hariom282538/lazyGit.git (fetch)
origin	git@github.com:hariom282538/lazyGit.git (push)
[master (root-commit) 3280c29] init
 1 file changed, 127 insertions(+)
 create mode 100755 .lazyGit.sh
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Delta compression using up to 4 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 1.46 KiB | 1.46 MiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To github.com:hariom282538/lazyGit.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

Case-2 Update/Existing

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
-bash: break: only meaningful in a `for', `while', or `until' loop
```

### How to run

Run this (supports linux/mac only):

```bash
chmod +x setup.sh
./setup.sh
```

##### The purpose of these script is to simplify daily git operations for programmers/DevOps. 

----
Want to contribute? Great!
 - [Connect ->  Hariom Vashisth](mailto:hariom.devops@gmail.com)