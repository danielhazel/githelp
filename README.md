# Git Help

## Some of Dan Hazel's bash scripts for his typical workflow

---
---
### Workflows
#### Merge-base workflow

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
#### gjb
 *Git Jira Branch*

USAGE: **gjb** *jiraissue*

gjb will:

1. show you the fixed versions declared on the jira item, 
2. prompt you for rel branches to target
3. find the best merge base to branch from to allow your new branch to be merged safely into master, it, rel/...
4. checkout a new branch at the point named after the jira description
5. push that branch to origin

gjb will give you opportunities to abort.

---
#### pulltargets
 *Pull locally discovered target branches*

USAGE: **pulltargets**

just pulls *master*, *it* and any *rel* branches it finds in the current repo

---
#### pull
 *Pull a named branch*

USAGE: **pull** *name*

1. pack up any outstanding changes in the current branch into a temp branch
2. check out *name* and pulls
3. check out the original branch and restores the stashed changes

---
#### pullto
 *Safely merge a local branch to a named target on the server using a pull request*

USAGE: **pullto** *target*

1. test that a merge from the current branch to the target will not conflict
2. push current branch to origin
3. create a pull request from origin current branch to origin target branch
4. merge pull request using no-ff strategy

pullto will give you opportunities to abort.

---
#### discosdu
 *Run sdu and check in changes to the origin schema repos*

USAGE: **discosdu** *sdu args*


1. prepare target Schema repos:
   - clean it
   - create new schema branches at the head of target with the same name as the current app branch

2. run sdu with the provided args

3. do roughly what pullto does for each of the schema apps, but using ff strategy

disco will give you opportunities to abort.

---
#### bestmergebase
 *Show the best merge-base to develop on from a list of target branches the work will eventually be merged into*

USAGE: **bestmergebase** *master* *it* *rel/1805* ... 

Look at all available merge bases and return the one with the fewest commit differences with master.

---
---
### Assumptions

Schema operations assume the target folder is /dev.  
   e.g. d:/Devl/DanH/AddOnPacks/Schema.CES/dev

That's because my other schema folders are just soft links back to dev
 
ls Ci2/AddOnPacks/**Schema.CES**

 dev/  
 it -> dev/  
 rel -> dev/  
 versrel/  
 
ls Ci2/AddOnPacks/**Schema.CES/versrel/**

 1711 -> ../dev/  
 1805 -> ../dev/  

If this is not your setup, discosdu might not work for you

---
---
### Prerequisites

 * Unix tools: grep; sed; awk; expr; ...  
You've probably got these if you're running bash.  I've been using cygwin but they seem to be available with the mingw64 that sourcetree spins up as terminal.
   
 * openssl
 
 * nodejs

 * curl
 
These are all available using t1get (I might not have been running the versions t1get will provide).
