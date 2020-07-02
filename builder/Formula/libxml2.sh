#!/bin/bash
#

brew_install_libxml2() {

    if [ ! -e $webox/cell/libxml2 ]; then
        brew install -v libxml2
        if_exit $?
    fi

    if [ ! -e $webox/include/libxml ]; then
        ln -s libxml2/libxml $webox/include/libxml
    fi

}
