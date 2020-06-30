#!/bin/bash
#

coretap=`brew --repository homebrew/core`
formula=$coretap/Formula/glibc.rb

if grep -q "glibc-2.23" $formula; then
    sed -i "s/glibc-2.23/glibc-2.24/g" $formula
    sed -i "/2bd08abb24811cda/d" $formula
    sed -i "/regexp.c/d" $formula
fi

if [ ! -d $whome/cell/glibc ]; then

    if ! type gawk >/dev/null 2>&1; then
        apt install -y gawk bison python3
    fi

    brew install -v glibc

fi
