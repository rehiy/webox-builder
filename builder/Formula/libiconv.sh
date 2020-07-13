#!/bin/bash
#

cell_install_libiconv() {

    if [ ! -d $webox/cell/libiconv ]; then
        brew install -v libiconv
        if_exit $?
    fi

    if [ ! -e $webox/include/iconv.h ]; then
        brew link --force libiconv
    fi

}
