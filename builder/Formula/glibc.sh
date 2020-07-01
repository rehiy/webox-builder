#!/bin/bash
#

coretap=`brew --repository homebrew/core`
formula=$coretap/Formula/glibc.rb

if grep -q "glibc-2.23" $formula; then
    sed -i "s/glibc-2.23/glibc-2.27/g" $formula
    sed -i "/2bd08abb24811cda/d" $formula
    sed -i "/regexp/d" $formula
fi

if [ ! -d $whome/cell/glibc ]; then

    if ! type gawk >/dev/null 2>&1; then
        apt install -y gawk bison python3
    fi

    brew install -v gcc@7 glibc

    cd $whome

    for vvv in `find cell/gcc@7/ -name "*.so.*"`; do
        ln -s -f ../$vvv $whome/lib
    done

    cd -

fi
