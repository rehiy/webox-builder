#!/bin/bash
#

brew_install_libxml2() {

    if [ ! -e $whome/cell/libxml2 ]; then
        brew install -v libxml2
        if_exit $?
    fi

    if [ ! -e $whome/include/libxml ]; then
        ln -s libxml2/libxml $whome/include/libxml
    fi

}
