#!/bin/bash
HERE=$(dirname ${BASH_SOURCE[0]})
. ${HERE}/fixpath

cd d:/Devl/${USER}/Ci2/AddOnPacks/
addonpacks=`pwd`

cmd=$@

for app in Workplace SystemManagement SystemIntegration SystemSecurity CpmCore DistributedProcessor; do
    cd $addonpacks
    cd ${app}/mcl/dev > /dev/null
    pwd
    if ! eval $cmd ; then >&2 echo exiting early; exit 1; fi
done
