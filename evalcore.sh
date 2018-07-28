#!/bin/bash
HERE=$(dirname ${BASH_SOURCE[0]})
. ${HERE}/fixpath

cd d:/devl/${USER}/Ci2/AddOnPacks
addonpacks=`pwd`

cmd=$@

cd $addonpacks
cd ../AppTier/dev
pwd
if ! eval $cmd ; then >&2 echo exiting early; exit 1; fi

cd $addonpacks
cd ../Webstart/dev
pwd
if ! eval $cmd ; then >&2 echo exiting early; exit 1; fi

cd $addonpacks
cd ../CoreLib/dev
pwd
if ! eval $cmd ; then >&2 echo exiting early; exit 1; fi

for app in Workplace SystemManagement SystemIntegration SystemSecurity CpmCore DistributedProcessor CrystalReports TerrificRetailCore TerrificRetailOrders; do
    cd $addonpacks
    cd ${app}/dev > /dev/null
    pwd
    if ! eval $cmd ; then >&2 echo exiting early; exit 1; fi
done
