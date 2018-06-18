#!/bin/bash

if [ -e _cleanup.sh ] ; then

    echo
    echo
    echo About to cleanup using
    cat _cleanup.sh
    
    echo -n "Okay to continue ... [y/n] "
    read okay
    if [ "$okay" != "y" -a "$okay" != "Y" ] ; then
        echo "Aborting cleanup."
        exit 1
    fi

    set -x
    . _cleanup.sh
    > _cleanup.sh
fi
