#!/bin/bash
#

brew_install_gcc() {

    if [ ! -d $webox/cell/gcc@7 ]; then
        brew install -v gcc@7
        if_exit $?
    fi

    cd $webox

    for vvv in `find cell/gcc@7/ -name "*.so.*"`; do
        ln -sf ../$vvv $webox/lib
    done

    cd -

}
