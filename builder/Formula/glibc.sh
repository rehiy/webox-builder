#!/bin/bash
#

cell_install_glibc() {

    cell_install_glibc_prefix

    if [ ! -d $webox/cell/glibc ]; then
        brew install -v glibc
    fi

    if ! locale charmap 2>/dev/null | grep -q UTF-8; then
        export LC_ALL="en_US.UTF-8"
    fi

}

cell_install_glibc_prefix() {

    local formula=`brew --repository homebrew/core`/Formula/glibc.rb

    if grep -q "glibc-2.23" $formula; then
        sed -i "s/glibc-2.23/glibc-2.27/g" $formula
        sed -i "/2bd08abb24811cda/d" $formula
        sed -i "/regexp/d" $formula
    fi

    if ! type gawk >/dev/null 2>&1; then
        apt install -y gawk bison python3
    fi

}
