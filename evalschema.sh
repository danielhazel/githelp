#!/bin/bash
HERE=$(dirname ${BASH_SOURCE[0]})
. ${HERE}/fixpath

cd d:/devl/${USER}/Ci2/AddOnPacks
addonpacks=`pwd`

cmd=$@

for app in Schema.CES Schema.Core Schema.ECM Schema.ECR Schema.PR Schema.SM ; do
    cd $addonpacks
    cd ${app}/dev > /dev/null
    pwd
    if ! eval $cmd ; then >&2 echo exiting early; exit 1; fi
done
