#!/bin/bash
#

cell_install_libxml2() {

    if [ ! -e $webox/cell/libxml2 ]; then
        brew install -v libxml2
        if_exit $?
    fi

    if [ ! -e $webox/include/libxml ]; then
        ln -sf libxml2/libxml $webox/include/libxml
    fi

}
