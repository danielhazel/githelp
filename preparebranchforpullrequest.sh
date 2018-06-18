#!/bin/bash
HERE=$(dirname ${BASH_SOURCE[0]})
. ${HERE}/fixpath

if [ "$#" -lt 1 ] ; then
    >&2 echo Usage: $0 targetBranch
    exit 1
fi

# This script checks that the current branch is mergeable to the target branch
# then deletes any server copy and pushes the current branch to the server

targetBranch=$1
startbranch=`git status | head -1 | sed -e 's/^On branch //'`


if ! branchexists "$targetBranch" ; then
    >&2 echo targetBranch: $targetBranch does not exist
    exit 1
fi

targetBranchCopy=${startbranch}_ResolveConflictTo_${targetBranch}
if branchexists "$targetBranchCopy" ; then
    echo deleting branch $targetBranchCopy
    git branch -D $targetBranchCopy
    git push origin --delete $targetBranchCopy 2> /dev/null
fi

if branchexists me ; then
    echo deleting branch me
    git branch -D me
fi


git checkout -b me
git checkout -b $targetBranchCopy $targetBranch

registerCleanup.sh git checkout $startbranch
registerCleanup.sh git branch -D $targetBranchCopy
registerCleanup.sh 'git push origin --delete '$targetBranchCopy' 2> /dev/null'

git merge me > /tmp/basegensafepullrequest$$.txt 2>&1

needcapitalY=
aborted=notaborted
if grep CONFLICT /tmp/basegensafepullrequest$$.txt ; then
    echo '**** ' "Warning: suspected conflict: piping yes will no longer work.  Must use Y below to proceed."
    needcapitalY=needcapitalY
else
    echo "No conflicts found."
fi
echo "Please check /tmp/basegensafepullrequest$$.txt and let me know when okay to createpullrequest (create pull requests) ... "
echo -n "[ y (yes) / n (abort) / ! (dont ask anymore) ] "
read okay

if [ -n "$needcapitalY" ] ; then
    if [ "$okay" = '!' ] ; then
        echo "Warning $okay being downgraded to Y because of earlier conflicts."
        okay=Y
    fi
fi
if [ "$okay" = '!' ] ; then
    echo
    echo "USER REQUESTED CAREER TO END!!"
elif [ -n "$needcapitalY" -a "$okay" != "Y" ] ; then
    echo "Aborting."
    aborted=aborted
elif [ "$okay" != "y" -a "$okay" != "Y" ] ; then
    echo "Aborting."
    aborted=aborted
fi

if [ $aborted = aborted ] ; then
    echo Tring to restore before exiting to original branch $startbranch ...
    if git status | grep 'git merge --abort' > /dev/null 2>&1 ; then
        git merge --abort
    else
        git reset --hard HEAD
        git checkout .
    fi
    git checkout $startbranch
    exit 1
fi

if [ -z "$needcapitalY" ] ; then
    # no conflicts were found.  change back to the original branch for server work.
    git reset HEAD
    git checkout .
    git checkout $startbranch
fi
currentbranch=$(branch)

if [ $currentbranch != master -a $currentbranch != it -a ${currentbranch:0:4} != "rel/" -a ${currentbranch:0:8} != "versrel/" ] ; then
    git push origin --delete $currentbranch 2> /dev/null
    git push -u origin $currentbranch
fi

echo $currentbranch pushed up.  Please issue a new pull request from $currentbranch to $targetBranch.
