#!/bin/bash
HERE=$(dirname ${BASH_SOURCE[0]})
. ${HERE}/fixpath

logfile=/tmp/basegensafepullrequest$$.txt
logfilefolder=$(dirname $logfile)
logfileleaf=$(basename $logfile)

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

registerCleanup.sh 'git checkout "'${startbranch}'"'
registerCleanup.sh 'git branch -D "'${targetBranchCopy}'"'
registerCleanup.sh 'git push origin --delete "'${targetBranchCopy}'" 2> /dev/null'

git merge me > $logfile 2>&1

needcapitalY=dontNeedCaptialY
aborted=notaborted
if grep CONFLICT $logfile ; then
    echo '**** ' "Warning: suspected conflict: piping yes will no longer work.  Must use Y below to proceed."
    echo
    echo '*********************************************************'
    echo "Before typing Y, you should "
    echo "  1. Resolve your conflicts"
    echo "  2. Commit your changes to the current temprory branch: "
    echo "      ${targetBranchCopy}"
    echo '*********************************************************'
    echo
    needcapitalY=needcapitalY
else
    echo "No conflicts found."
fi
echo "Please check $logfile and let me know when okay to createpullrequest (create pull requests) ... "
echo "(Provide the name of a viewer here if you want me to view logs with that in future.)"
yes=y
if [ $needcapitalY = needcapitalY  ] ; then
   yes=Y
fi
viewer=$(logviewer)

okay=nothingyet
while [ $okay = nothingyet ] ; do
    echo
    echo -n "[ ${yes} (yes) / n (abort) / v (view using ${viewer}) / ! (dont ask anymore) ] "
    read okay
    
    if [ $okay = "v" -o $okay = "V" ] ; then
        okay=nothingyet
        ( cd $logfilefolder ; $viewer $logfileleaf )
    elif [ $okay != '!' -a $okay != 'y' -a $okay != 'Y' -a $okay != 'n' -a $okay != 'N' ] ; then
        setlogviewer $okay
        okay=nothingyet
        viewer=$(logviewer)
        ( cd $logfilefolder ; $viewer $logfileleaf )
    fi
done

if [ $needcapitalY = needcapitalY  ] ; then
    if [ "$okay" = '!' ] ; then
        echo "Warning $okay being downgraded to Y because of earlier conflicts."
        okay=Y
    fi
fi
if [ "$okay" = '!' ] ; then
    echo
    echo "USER REQUESTED CAREER TO END!!"
elif [ $needcapitalY = needcapitalY -a "$okay" != "Y" ] ; then
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

if [ $needcapitalY = dontNeedCaptialY ] ; then
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
