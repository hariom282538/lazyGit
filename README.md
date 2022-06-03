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

## Case-4 Show modified files in selected commit

bash```
HARIOM-MAC:lazyGit $ lazygit -s 
show was triggered, Parameter: 
1) 96e4aa2:prompt_msg_updated:hariom.devops@gmail.com:2022-06-03 16:51:37 +0530                                                                                                                
2) a5f5313:readme-updated:hariom.devops@gmail.com:2022-06-03 16:50:31 +0530                                                                                                                    
3) 6b45b8f:compatibility_with_new_mac_upgrades:hariom.devops@gmail.com:2022-06-03 16:44:15 +0530                                                                                               
4) df33155:c1:hariom.devops@gmail.com:2022-06-02 20:00:30 +0530                                                                                                                                
5) e288f27:c1:hariom.devops@gmail.com:2022-06-02 19:43:47 +0530                                                                                                                                
6) a8b1a18:c1:hariom.devops@gmail.com:2022-06-02 19:43:16 +0530                                                                                                                                
7) e8ee31a:c1:hariom.devops@gmail.com:2022-06-02 19:42:16 +0530                                                                                                                                
8) 370109d:c1:hariom.devops@gmail.com:2022-06-02 19:41:37 +0530                                                                                                                                
9) 4cf93dc:c1:hariom.devops@gmail.com:2022-06-02 19:40:39 +0530                                                                                                                                
10) 3f27147:c1:hariom.devops@gmail.com:2022-06-02 19:39:43 +0530                                                                                                                               
11) Quit                                                                                                                                                                                       
Please select an item: 2
Modified Files: a5f5313
README.md                                                                                                                               
```

# How to run

Run this (linux/mac bash-terminal only):

```bash
chmod +x setup.sh
./setup.sh
```
or
```bash
    cp .lazyGit.sh ~/
    echo 'source ~/.lazyGit.sh' >>~/.bashrc
    source ~/.bashrc
```

## Use
```bash
lazygit -u commit_msg # [u]:stands for upload[push] changes
lazygit -d # [d]:stands for download[pull] changes
lazygit -s # [s]:it shows files modified in selected commits
lazygit commit_msg # for setting-up new projects
```

### Features

- Pull
   - Current branch
   - Existing other branches
   - Cherry-pick

- Push
   - Current branch
   - Existing other branches
   - New branch

- Show
   - easy way to get commit details
   - easy way to see modified files in specific commit without knowing the commit-id

##### The purpose of these script is to simplify daily git operations for programmers/DevOps. 

----
Want to contribute? Great!
 - [Connect ->  Hariom Vashisth](mailto:hariom.devops@gmail.com)
