# Git Help

## Some of Dan Hazel's bash scripts for his typical workflow

---
---
### Workflows
#### My merge-base workflow

0. **pulltargets**

1. **gjb** CCP-12345

2. *make changes*

3. git push

4. **pull** master

5. **pullto** master

6. **pull** it

7. **pullto** it

8. **pull** rel/1805

9. **pullto** rel/1805


#### sdu and schema workflow

1. **discosdu** *usual sdu arguments*

---
---
### Command descriptions

---
#### j2b
 *Jira Description to Branch Name*

###### USAGE: 
 **j2b** *jiraissue*

j2b will:

1. generate a git branch name from a jira description

The branch name is echoed to stdout.

###### Example:

**$** `j2b CCP-17382`

danh/feature/CCP-17382----_Investigate_push_notifications_for_CiAnywhere

---
#### gjb
 *Git Jira Branch*

###### USAGE:
 **gjb** *jiraissue*

gjb will:

1. show you the fixed versions declared on the jira item, 
2. prompt you for rel branches you plan to target
3. find the best merge base to branch from to allow your new branch to be merged safely into master, it, rel/...
4. checkout a new branch at the point named after the jira description
5. push that branch to origin

gjb will give you opportunities to abort.

---
#### pulltargets
 *Pull locally discovered target branches*

###### USAGE:
 **pulltargets**

just pulls *master*, *it* and any *rel* branches it finds in the current repo

---
#### pull
 *Pull a named branch*

###### USAGE:
 **pull** *name*

pull will:

1. pack up any outstanding changes in the current branch into a temp branch
2. check out *name* and pull
3. check out the original branch and restore the "stashed" changes

---
#### pullto
 *Safely merge a local branch to a named target on the server using a pull request*

###### USAGE:
 **pullto** *target*

pullto will: 

1. test that a merge from the current branch to the target will not conflict
2. push current branch to origin
3. create a pull request from origin current branch to origin target branch
4. merge pull request using no-ff strategy

pullto will give you opportunities to abort.

---
#### discosdu
 *Run sdu and check in changes to the origin schema repos*

###### USAGE:
 **discosdu** *sdu args*

discosdu will:

1. prepare target Schema repos:
   - clean them
   - create new schema branches at the head of target with the same name as the current app branch

2. run sdu with the provided args

3. do roughly what pullto does for each of the schema apps, but using ff strategy

disco will give you opportunities to abort.

---
#### bestmergebase
 *Show the best merge-base to develop on from a list of target branches the work will eventually be merged into*

###### USAGE:
 **bestmergebase** *master* *it* *rel/1805* ... 

bestmergebase will:

Look at all available merge bases of the branch names given to it as arguments, and return the one with the fewest commit differences with master.

---
#### b2m
 *Branch name to commit message*

###### USAGE:
 **b2m** *jiraissue*

b2m will:

1. read a branch name from stdin and echo the corresponding commit message to stdout

###### Example:

**$** `echo danh/feature/CCP-17382----_Investigate_push_notifications_for_CiAnywhere | b2m`

CCP-17382: Investigate push notifications for CiAnywhere

---
#### branch
 *Current branch name*

###### USAGE:
 **branch**

branch will:

1. echo the current working branch name to stdout

###### Examples:

**$** `branch`

danh/feature/CCP-17382----_Investigate_push_notifications_for_CiAnywhere

**$** `git commit -m "$(branch | b2m)"`


---
---
### Prerequisites

Hopefully everything you need is already installed on your Amazon Workspace.

 * Unix tools: grep; sed; awk; expr; ...  
These already seem to be available in the mingw64 bash terminal that launches when you click the Terminal icon in Sourcetree.
   
 * t1get install openssl
 
 * t1get install nodejs

 * t1get install curl
 
---
---
### Tips

---
#### The Bitbucket api is sometimes case sensitive about your email address

If you run into trouble with the **pullto** steps that create pull requests/merge pull requests:
  + Run `refreshsavedjiracredentials`
  + make sure the email address you provide uses the same casing as the email shown in your <https://git.code.one/account>.

---
#### Your jira password needs to be the same as your bitbucket password

If you run into trouble with the **pullto** steps that create pull requests/merge pull requests:
  + Change your bitbucket password to your jira password or change your jira password to your bitbucket password
  + Run `refreshsavedjiracredentials`
